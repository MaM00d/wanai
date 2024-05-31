
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

quantization_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_use_double_quant=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.bfloat16,
)


# |%%--%%| <ph7BpuuNu4|bJiEV2rkNZ>

torch.cuda.is_available()

# |%%--%%| <bJiEV2rkNZ|a6wRStxEew>

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

# |%%--%%| <PfI0aEsFKv|rEipDtIjCQ>

lora_config = LoraConfig.from_pretrained(
    "TheMETeam/wanas-finetuned"
)
model = get_peft_model(model, lora_config)

# |%%--%%| <rEipDtIjCQ|BaFBVgPlLF>

text = create_prompt("", "اهلا يا دكتور", "")

# |%%--%%| <BaFBVgPlLF|wLo5wkawTI>

device = "cuda:0"

inputs = tokenizer(text, return_tensors="pt").to(device)
outputs = model.generate(**inputs, max_new_tokens=50)

print(tokenizer.decode(outputs[0], skip_special_tokens=True))

# |%%--%%| <wLo5wkawTI|uLA60Y96Ri>

text = create_prompt("", "ليه مموتش مريم", "")

# |%%--%%| <uLA60Y96Ri|zxumPTHs1y>

device = "cuda:0"

inputs = tokenizer(text, return_tensors="pt").to(device)
outputs = model.generate(**inputs, max_new_tokens=50)

print(tokenizer.decode(outputs[0], skip_special_tokens=True))

