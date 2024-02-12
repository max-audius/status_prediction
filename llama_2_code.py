import torch
import fairscale
import fire
import sentencepiece
print(torch.cuda.is_available())
print(torch.cuda.device_count())
# print(torch.cuda.get_device_name(0))

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(device)


from llama_cpp import Llama

# Load the Llama 2 model
# LLM = Llama(model_path="./llama-2-7b-chat.ggmlv3.q8_0.bin")
LLM = Llama(model_path="C:/Users/Admin/OneDrive - The University of Liverpool/Documents/Dr Procheta/LeSICiN/llama/llama/model", n_gqa=8, # add this
n_threads=2)

prompt = "What is the meaning of life?"

response = LLM.generate_text(prompt, num_sentences=5)

print(response)

