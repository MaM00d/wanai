!pip install transformers
!pip3 install torch torchvision torchaudio
!pip install bitsandbytes
!pip install accelerate
!pip install peft

# |%%--%%| <nCEL7HvfsY|KwYlAwiGnU>

from transformers import BitsAndBytesConfig
import torch, peft
from peft import LoraConfig, get_peft_model

# |%%--%%| <KwYlAwiGnU|ph7BpuuNu4>

# specify how to quantize the model
quantization_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_use_double_quant=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.bfloat16,
)

# device_map = {"": torch.cuda.current_device()} if torch.cuda.is_available() else None

# |%%--%%| <ph7BpuuNu4|bJiEV2rkNZ>

torch.cuda.is_available()

#|%%--%%| <bJiEV2rkNZ|OUNR0pFP4G>

from transformers import AutoTokenizer, AutoModelForCausalLM
model_id = "FreedomIntelligence/AceGPT-13B"

tokenizer = AutoTokenizer.from_pretrained(model_id)

#|%%--%%| <OUNR0pFP4G|eT1C2QVzMN>

device = "cuda:0"
inputs = tokenizer("اهلا اهلا بالعيد", return_tensors="pt").to(device)
print(inputs)


# |%%--%%| <eT1C2QVzMN|a6wRStxEew>

# Load model directly
from transformers import AutoTokenizer, AutoModelForCausalLM

model_id = "FreedomIntelligence/AceGPT-13B"

tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(
    model_id, quantization_config=quantization_config, device_map={"": 0}
)

# |%%--%%| <a6wRStxEew|PfI0aEsFKv>


def create_prompt(history, patient, doctor):
    prompt_template = (
        f"### HISTORY\n{history}\n\n### PATIENT\n{patient}\n\n### DOCTOR\n{doctor}</s>"
    )
    return prompt_template


# |%%--%%| <PfI0aEsFKv|wRldk3bSk9>

from peft import AutoPeftModelForCausalLM

# eltoken = "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"
ourmodel = AutoPeftModelForCausalLM.from_pretrained(
    "/home/me/loc/.hfcache/hub/models--FreedomIntelligence--AceGPT-13B/snapshots/4ceb8c997a28c82f8cd3f55834d690f19456f5df/",
    token=eltoken,
)

# |%%--%%| <wRldk3bSk9|rEipDtIjCQ>

lora_config = LoraConfig.from_pretrained(
    "/home/me/loc/.hfcache/hub/models--hader1234--wanas_trained/snapshots/d750e8bd4279fa561fe295af85e70a3229ad7079"
)
model = get_peft_model(model, lora_config)

#|%%--%%| <rEipDtIjCQ|S0jt0h4bQV>


import torch
from transformers import AutoModelForSequenceClassification, AutoTokenizer

# load model and tokenizer
model_id = "distilbert-base-uncased-finetuned-sst-2-english"
model = AutoModelForSequenceClassification.from_pretrained(model_id)
tokenizer = AutoTokenizer.from_pretrained(model_id)
dummy_model_input = tokenizer("This is a sample", return_tensors="pt")

# export
torch.onnx.export(
    model, 
    tuple(dummy_model_input.values()),
    f="torch-model.onnx",  
    input_names=['input_ids', 'attention_mask'], 
    output_names=['logits'], 
    dynamic_axes={'input_ids': {0: 'batch_size', 1: 'sequence'}, 
                  'attention_mask': {0: 'batch_size', 1: 'sequence'}, 
                  'logits': {0: 'batch_size', 1: 'sequence'}}, 
    do_constant_folding=True, 
    opset_version=13, 
)

# |%%--%%| <S0jt0h4bQV|BaFBVgPlLF>

text = create_prompt("", "ازيك يا دكتور عامل اي؟", "")

# |%%--%%| <BaFBVgPlLF|wLo5wkawTI>

device = "cuda:0"

inputs = tokenizer(text, return_tensors="pt").to(device)
outputs = model.generate(**inputs, max_new_tokens=50)

print(tokenizer.decode(outputs[0], skip_special_tokens=True))

# |%%--%%| <wLo5wkawTI|uLA60Y96Ri>


# |%%--%%| <uLA60Y96Ri|zxumPTHs1y>
