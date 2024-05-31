
 # !pip install datasets
# !pip install transformers==4.30
# !pip install trl
# !pip install flash-attn --no-build-isolation
# !pip install -q bitsandbytes trl peft
# !pip install torch
# !pip install transformers[torch]
# !pip install accelerate -U

# |%%--%%| <bufIlroDNO|QSzFFjuUrn>

# !pip install auto-gptq
# !pip install optimum
# !pip install bitsandbytes
# !pip uninstall torch -y
# !pip install torch==2.1

#|%%--%%| <QSzFFjuUrn|HA8dtrbm2q>
r"""°°°
# Installing The Packages
°°°"""
# |%%--%%| <HA8dtrbm2q|ZxT6dAQpBh>

# !pip3 install transformers peft datasets bitsandbytes accelerate
# !pip3 install torch torchvision torchaudio
#|%%--%%| <ZxT6dAQpBh|cRnsFSg5Uz>

!pip install accelerate
!pip install -i https://pypi.org/simple/ bitsandbytes


# |%%--%%| <cRnsFSg5Uz|q3A4CyvleE>

from transformers import AutoModelForCausalLM, AutoTokenizer,BitsAndBytesConfig,DataCollatorForLanguageModeling,TrainingArguments,Trainer
from peft import prepare_model_for_kbit_training
from peft import LoraConfig, get_peft_model
from datasets import load_dataset
import torch

#|%%--%%| <q3A4CyvleE|WbG5IYTkrX>
r"""°°°
# creating the quantization of QLORA for the modle nad using 4bit 
°°°"""
# |%%--%%| <WbG5IYTkrX|g5ifTzA2Cf>

# specify how to quantize the model
quantization_config = BitsAndBytesConfig(
            load_in_4bit=True,
            bnb_4bit_use_double_quant=True,
            bnb_4bit_quant_type="nf4",
            bnb_4bit_compute_dtype=torch.bfloat16
)



#|%%--%%| <g5ifTzA2Cf|A8dtz1cLVl>
r"""°°°
# Loading the ACEGPT llm Model 
°°°"""
# |%%--%%| <A8dtz1cLVl|LI4Q8C9HrK>

model_id = "FreedomIntelligence/AceGPT-13B"
tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(model_id, quantization_config=quantization_config, device_map={"":0})

# |%%--%%| <LI4Q8C9HrK|XAS9bj0OVS>


if tokenizer.pad_token_id is None:
  tokenizer.pad_token_id = tokenizer.eos_token_id

if tokenizer.model_max_length > 100_000:
  tokenizer.model_max_length = 2048


data_collator = DataCollatorForLanguageModeling(tokenizer, mlm=False)




# |%%--%%| <XAS9bj0OVS|1v2zXQPFy7>

dataset = load_dataset("csv", data_files="datasetmaker/wannas_final.csv",split='train')

# |%%--%%| <1v2zXQPFy7|qEY0aAIx1l>

dataset=dataset.train_test_split(test_size=0.3)

# |%%--%%| <qEY0aAIx1l|wmMbxJMBvu>

dataset

# |%%--%%| <wmMbxJMBvu|MvzsB5Lk6R>

def create_prompt(history, patient, doctor):
  prompt_template = f"### HISTORY\n{history}\n\n### PATIENT\n{patient}\n\n### DOCTOR\n{doctor}</s>"
  return prompt_template

wanas_dataset = dataset.map(lambda samples: tokenizer(create_prompt(samples['history'], samples['patient'], samples['doctor'])))

# |%%--%%| <MvzsB5Lk6R|2DWQYtIeqO>

#with context

def create_prompt(history, patient, doctor, context):
    prompt_template = f"""
    ```wanasgpt[INST]\n
    إنت دكتور نفسي متعاطف ومهتم بمساعدة الناس عشان يلاقوا حلول لمشاكلهم.
     هدفك الأساسي هو إنك تخلق مساحة آمنة للناس عشان يعبروا عن نفسهم ويستكشفوا أفكارهم ومشاعرهم.
     خلال الحوار، ركز على الاستماع الفعال، تقديم الدعم، وتوجيه الشخص لحلول محتملة.
     شجّع الشخص إنه يعبر عن مشاعره بشكل مفتوح عن طريق طرح أسئلة محفزة ومفتوحة بتشجع النقاش.

    {context}
    ### المحادثات السابقة بينك وبين المريض:\n{ history }\n\n### رسالة المريض المطلوب الرد عليها:\n{ patient }\n\n### ردك على رسالة المريض:\n{ doctor }<\s>\n[/INST]wanasgpt```
    """

    return prompt_template

wanas_dataset = dataset.map(lambda samples: tokenizer(create_prompt(samples['history'], samples['patient'], samples['doctor'],"context")))

# |%%--%%| <2DWQYtIeqO|j1dF6O5tpG>

model.train() # model in training mode (dropout modules are activated)

# enable gradient check pointing
model.gradient_checkpointing_enable()

# enable quantized training
model = prepare_model_for_kbit_training(model)

# |%%--%%| <j1dF6O5tpG|05k9hJzkyc>

print(model)

# |%%--%%| <05k9hJzkyc|zOAHkjPwip>

torch.cuda.is_available()

# |%%--%%| <zOAHkjPwip|eegrZX5NPF>

config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)

# LoRA trainable version of model
model = get_peft_model(model, config)

# trainable parameter count
model.print_trainable_parameters()

# |%%--%%| <eegrZX5NPF|xDmNA8PKhG>

# hyperparameters
lr = 2e-4
batch_size = 4
num_epochs = 50

# define training arguments
training_args = TrainingArguments(
    output_dir= "wanasgpt-ft",
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

# |%%--%%| <xDmNA8PKhG|G5NaccM6JS>

# configure trainer
trainer = Trainer(
    model=model,
    train_dataset=wanas_dataset["train"],
     eval_dataset=wanas_dataset["test"],
    args=training_args,
     data_collator=data_collator
)




# |%%--%%| <G5NaccM6JS|TnXx310C1h>

# train model
# model.config.use_cache = False  # silence the warnings. Please re-enable for inference!
trainer.train()

# renable warnings
# model.config.use_cache = True

#|%%--%%| <TnXx310C1h|gnJxMlrpaY>

from huggingface_hub import notebook_login

notebook_login()

# |%%--%%| <gnJxMlrpaY|ZVPRkHaMhL>

HUGGING_FACE_USER_NAME = 'TheMETeam'
model_name ='wanas-finetuned'

# |%%--%%| <ZVPRkHaMhL|yXYZta268S>

trainer.push_to_hub(f"{HUGGING_FACE_USER_NAME}/{model_name}", use_auth_token=True)

