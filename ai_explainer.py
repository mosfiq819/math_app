from typing import List, Dict, Any
import openai
import os

class AIExplainer:
    def __init__(self, api_key: str = None):
        self.api_key = api_key or os.getenv("OPENAI_API_KEY")
        if self.api_key:
            self.client = openai.OpenAI(api_key=self.api_key)
        else:
            self.client = None
    
    async def explain_steps(self, problem: str, answer: str, 
                           steps: List[str], language: str = "en") -> List[str]:
        """Generate detailed explanations for steps"""
        
        if not self.client:
            # Return original steps if no API key
            return steps
        
        try:
            if language == "bn":
                prompt = f"""
                আপনি একজন গণিত শিক্ষক। নিচের সমস্যাটি বাংলায় বুঝিয়ে দিন:
                
                সমস্যা: {problem}
                সমাধান: {answer}
                
                নিচের ধাপগুলো আরও বিস্তারিতভাবে ব্যাখ্যা করুন:
                {chr(10).join(f'{i+1}. {step}' for i, step in enumerate(steps))}
                
                বাংলায় ৩-৫টি সহজ ধাপে ব্যাখ্যা দিন। প্রতিটি ধাপে সূত্র এবং যুক্তি উল্লেখ করুন।
                """
            else:
                prompt = f"""
                You are a math tutor. Explain this problem step by step:
                
                Problem: {problem}
                Solution: {answer}
                
                Explain these steps in more detail:
                {chr(10).join(f'{i+1}. {step}' for i, step in enumerate(steps))}
                
                Provide 3-5 clear steps in simple language.
                Include relevant formulas and reasoning.
                """
            
            response = self.client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "You are a helpful math tutor."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.3,
                max_tokens=500
            )
            
            explanation = response.choices[0].message.content
            # Split into steps
            explained_steps = [step.strip() for step in explanation.split('\n') if step.strip()]
            
            return explained_steps
            
        except Exception as e:
            print(f"AI Explanation error: {e}")
            return steps  # Fallback to original steps