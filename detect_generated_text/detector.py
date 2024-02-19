import nltk
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.probability import FreqDist
from transformers import GPT2LMHeadModel, GPT2Tokenizer
import torch

# For development only - need to be removed in production
import ssl
ssl._create_default_https_context = ssl._create_unverified_context
# For development only - need to be removed in production

model_name = 'gpt2-medium'
tokenizer = GPT2Tokenizer.from_pretrained(model_name)
model = GPT2LMHeadModel.from_pretrained(model_name)
nltk.download('punkt')

class detector():
    def __init__(self) -> None:
        pass

    def text_complexity(self, text):
        sentences = sent_tokenize(text)
        words = word_tokenize(text)
        vocab = set(words)
        complexity_score = len(vocab) / len(sentences)
        return complexity_score

    def calculate_perplexity(self, text):
        tokenize_input = tokenizer.encode(text, return_tensors="pt")
        loss = model(tokenize_input, labels=tokenize_input).loss
        return torch.exp(loss).item()

    def analyze_text(self, text):
        complexity = self.text_complexity(text)
        perplexity = self.calculate_perplexity(text)

        complexity = round(complexity, 2)
        perplexity = round(perplexity, 2)
        if complexity < 5 or perplexity > 50: 
            decision = "AI-generated"
        else:
            decision = "Human-written"
        return {
            "complexity": complexity,
            "perplexity": perplexity,
            "decision": decision
        }
