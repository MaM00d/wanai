# |%%--%%| <c9AXsMSZl5|NgWEZicMYY>
r"""°°°
# lOAD QUANTIZED MODEL
°°°"""
# |%%--%%| <NgWEZicMYY|cgdY3m6XoC>

AceGptModelName = "FreedomIntelligence/AceGPT-13B"

# |%%--%%| <cgdY3m6XoC|xaIkSdCqVo>

from transformers import BitsAndBytesConfig
import torch
quantization_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_use_double_quant=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.bfloat16,
)


from transformers import AutoTokenizer, AutoModelForCausalLM


tokenizer = AutoTokenizer.from_pretrained(AceGptModelName)
model = AutoModelForCausalLM.from_pretrained(
    AceGptModelName, quantization_config=quantization_config, device_map={"": 0}
)

# |%%--%%| <xaIkSdCqVo|oF82z51kT5>
r"""°°°
# LOAD NORMAL MODEL
°°°"""
# |%%--%%| <oF82z51kT5|C6MK0rJytB>

# normal_model = AutoModelForCausalLM.from_pretrained(
#     AceGptModelName
# )

# |%%--%%| <C6MK0rJytB|MOIKuoKUEz>
r"""°°°
# Load Tokenizer
°°°"""
# |%%--%%| <MOIKuoKUEz|FlZvcdFzEd>

tokenizer = AutoTokenizer.from_pretrained(AceGptModelName)

# |%%--%%| <FlZvcdFzEd|wCoJ7Ypu7N>
r"""°°°
# Prompts
°°°"""
# |%%--%%| <wCoJ7Ypu7N|USy69Uu1t5>
r"""°°°
## Old Prompt After Adding Context
°°°"""
# |%%--%%| <USy69Uu1t5|28yidCEtCe>

def create_prompt(context, history ,patient, doctor):
    prompt_template = (
        f"### Context\n{context}\n{history}\n\n### PATIENT\n{patient}\n\n### DOCTOR\n{doctor}</s>"
    )
    return prompt_template

#|%%--%%| <28yidCEtCe|xqSx0cprsq>
r"""°°°
# Loading Datasets
## spliting test and train datasets
°°°"""
#|%%--%%| <xqSx0cprsq|ljsPV7YxHJ>
from datasets import load_dataset
dataset = load_dataset("csv", data_files="./datasets/large_dataset.csv",split='train')
dataset=dataset.train_test_split(test_size=0.3)
dataset = dataset.map(lambda samples: tokenizer(create_prompt("",samples['history'], samples['patient'], samples['doctor'])))
# |%%--%%| <ljsPV7YxHJ|qioYjjzgvX>
r"""°°°
# Training  
°°°"""
#|%%--%%| <qioYjjzgvX|XnkmnXVf6G>
r"""°°°
## Set Model in Training Mode
°°°"""
#|%%--%%| <XnkmnXVf6G|hGGt31gRO8>
train_model = model
train_model.train() # model in training mode (dropout modules are activated)

# enable gradient check pointing
train_model.gradient_checkpointing_enable()


#|%%--%%| <hGGt31gRO8|o5JzsHriIN>
r"""°°°
### enable quantized training
°°°"""
#|%%--%%| <o5JzsHriIN|iVvPzQFh7Q>
from peft.utils.other import prepare_model_for_kbit_training
from peft.mapping import get_peft_model
from peft.config import LoraConfig 

train_model = prepare_model_for_kbit_training(train_model)

config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)

# LoRA trainable version of model
train_model = get_peft_model(train_model, config)

# trainable parameter count
train_model.print_trainable_parameters()

#|%%--%%| <iVvPzQFh7Q|pjp5RSawVQ>
r"""°°°
## Setting Training Args
°°°"""
#|%%--%%| <pjp5RSawVQ|dTGapDXWvU>
from transformers import TrainingArguments
# hyperparameters
lr = 2e-4
batch_size = 4
num_epochs = 50
output_dir= "wanasgpt-ft"

# define training arguments
training_args = TrainingArguments(
    output_dir=output_dir ,
    learning_rate=lr,
    per_device_train_batch_size=batch_size,
    per_device_eval_batch_size=batch_size,
    num_train_epochs=num_epochs,
    weight_decay=0.01,
    logging_strategy="epoch",
    evaluation_strategy="epoch",
    save_strategy="epoch",
    load_best_model_at_end=True,
    gradient_accumulation_steps=4,
    warmup_steps=2,
    fp16=True,
    optim="paged_adamw_8bit",

)

#|%%--%%| <dTGapDXWvU|gpd4Y6Ezwm>
r"""°°°
## Input Padding
°°°"""
# |%%--%%| <gpd4Y6Ezwm|Vr8LqCHfEQ>

from transformers import DataCollatorForLanguageModeling
if tokenizer.pad_token_id is None:
  tokenizer.pad_token_id = tokenizer.eos_token_id

if tokenizer.model_max_length > 100_000:
  tokenizer.model_max_length = 2048


data_collator = DataCollatorForLanguageModeling(tokenizer, mlm=False)



#|%%--%%| <Vr8LqCHfEQ|3Q5AMUz7fq>
r"""°°°
## Make trainer Object
°°°"""
#|%%--%%| <3Q5AMUz7fq|eIRPXquB3e>
from transformers import Trainer
trainer = Trainer(
    model=train_model,
    train_dataset=dataset["train"],
     eval_dataset=dataset["test"],
    args=training_args,
     data_collator=data_collator
)

#|%%--%%| <eIRPXquB3e|vHZzmdU8Ol>
r"""°°°
Start Training 
°°°"""
#|%%--%%| <vHZzmdU8Ol|5V9PlMScSK>
# train model
# model.config.use_cache = False  # silence the warnings. Please re-enable for inference!

trainer.train()

# renable warnings
# model.config.use_cache = True
#|%%--%%| <5V9PlMScSK|Tjn521kGVM>
r"""°°°
#Model Using
°°°"""
#|%%--%%| <Tjn521kGVM|LrJWcimgC9>
from peft import LoraConfig 
lora_config = LoraConfig.from_pretrained(
    output_dir + "wanas-finetuned"
)
peft_model = get_peft_model(model, lora_config)

# |%%--%%| <LrJWcimgC9|BaFBVgPlLF>

text = create_prompt("","", "اهلا يا دكتور", "")
device = "cuda:0"
inputs = tokenizer(text, return_tensors="pt").to(device)
outputs = peft_model.generate(**inputs, max_new_tokens=50)
print(tokenizer.decode(outputs[0], skip_special_tokens=True))

#|%%--%%| <BaFBVgPlLF|mvGx7zj4Xo>
!pip install --upgrade huggingface-hub
!pip install --upgrade transformers
# get your account token from https://huggingface.co/settings/tokens
token = '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'
# import the relavant libraries for loggin in
from huggingface_hub import HfApi, HfFolder

# set api for login and save token
api=HfApi()
api.set_access_token(token)
folder = HfFolder()
folder.save_token(token)


# |%%--%%| <mvGx7zj4Xo|uLA60Y96Ri>

model.push_to_hub("my-awesome-model")
