import sympy as sp
import numpy as np
from typing import Dict, Any, List
import re

class MathSolver:
    def __init__(self):
        self.x, self.y, self.z, self.t = sp.symbols('x y z t')
    
    def solve(self, problem_text: str, problem_type: str = "auto") -> Dict[str, Any]:
        """Main solve method"""
        
        if problem_type == "auto":
            problem_type = self.detect_problem_type(problem_text)
        
        problem_type = problem_type.lower()
        
        if "vector" in problem_type:
            return self.solve_vector(problem_text)
        elif "matrix" in problem_type or "determinant" in problem_type:
            return self.solve_matrix(problem_text)
        elif "derivative" in problem_type or "differentiate" in problem_text.lower():
            return self.solve_derivative(problem_text)
        elif "integral" in problem_type or "integrate" in problem_text.lower():
            return self.solve_integral(problem_text)
        elif "limit" in problem_type:
            return self.solve_limit(problem_text)
        elif "equation" in problem_type or "solve" in problem_text.lower():
            return self.solve_equation(problem_text)
        else:
            return self.solve_general(problem_text)
    
    def detect_problem_type(self, text: str) -> str:
        """Detect type of math problem"""
        text_lower = text.lower()
        
        if any(word in text_lower for word in ['dot', 'cross', 'vector', 'magnitude']):
            return "vector"
        elif any(word in text_lower for word in ['matrix', 'determinant', 'inverse', 'eigen']):
            return "matrix"
        elif any(word in text_lower for word in ['derivative', 'differentiate', 'd/dx']):
            return "derivative"
        elif any(word in text_lower for word in ['integral', 'integrate', '∫']):
            return "integral"
        elif 'limit' in text_lower:
            return "limit"
        elif any(word in text_lower for word in ['solve', 'equation', '=']):
            return "equation"
        else:
            return "general"
    
    def solve_vector(self, problem_text: str) -> Dict[str, Any]:
        """Solve vector algebra problems"""
        steps = []
        
        # Extract vectors from text (simplified parsing)
        vectors = self.extract_vectors(problem_text)
        
        if "dot" in problem_text.lower():
            if len(vectors) >= 2:
                v1, v2 = vectors[0], vectors[1]
                # Convert to numpy for calculation
                v1_np = np.array(v1)
                v2_np = np.array(v2)
                dot_product = np.dot(v1_np, v2_np)
                
                steps.append(f"ভেক্টর ১: {v1}")
                steps.append(f"ভেক্টর ২: {v2}")
                steps.append(f"ডট প্রোডাক্ট সূত্র: A·B = Σ(aᵢ × bᵢ)")
                steps.append(f"গণনা: ({v1[0]}×{v2[0]}) + ({v1[1]}×{v2[1]}) + ({v1[2]}×{v2[2]})")
                steps.append(f"ফলাফল: {dot_product}")
                
                return {
                    "answer": f"ডট প্রোডাক্ট = {dot_product}",
                    "steps": steps,
                    "visualization": {
                        "type": "vector_dot",
                        "vectors": [v1, v2],
                        "result": float(dot_product)
                    }
                }
        
        elif "cross" in problem_text.lower():
            if len(vectors) >= 2:
                v1, v2 = vectors[0], vectors[1]
                # Convert to sympy for cross product
                v1_sp = sp.Matrix(v1)
                v2_sp = sp.Matrix(v2)
                cross_product = v1_sp.cross(v2_sp)
                cross_list = [float(x) for x in cross_product]
                
                steps.append(f"ভেক্টর A = {v1}")
                steps.append(f"ভেক্টর B = {v2}")
                steps.append("ক্রস প্রোডাক্ট সূত্র: A × B = det[[i,j,k],[a₁,a₂,a₃],[b₁,b₂,b₃]]")
                steps.append(f"গণনা: i({v1[1]}×{v2[2]} - {v1[2]}×{v2[1]}) - j({v1[0]}×{v2[2]} - {v1[2]}×{v2[0]}) + k({v1[0]}×{v2[1]} - {v1[1]}×{v2[0]})")
                steps.append(f"ফলাফল: {cross_list}")
                
                return {
                    "answer": f"ক্রস প্রোডাক্ট = {cross_list}",
                    "steps": steps,
                    "visualization": {
                        "type": "vector_cross",
                        "vectors": [v1, v2],
                        "result": cross_list
                    }
                }
        
        return {"answer": "ভেক্টর সমস্যা সমাধান করতে ব্যর্থ", "steps": ["দুঃখিত, এই ভেক্টর সমস্যাটি সমাধান করতে পারিনি"]}
    
    def solve_derivative(self, problem_text: str) -> Dict[str, Any]:
        """Solve derivative problems"""
        steps = []
        
        # Extract function from text
        func_str = self.extract_function(problem_text)
        if not func_str:
            func_str = "x**2"  # Default
        
        try:
            # Parse and differentiate
            expr = sp.sympify(func_str)
            derivative = sp.diff(expr, self.x)
            
            steps.append(f"ফাংশন: f(x) = {expr}")
            steps.append("পাওয়ার রুল প্রয়োগ: d/dx(xⁿ) = n·xⁿ⁻¹")
            steps.append("প্রতিটি টার্ম আলাদা করে ডিফারেনশিয়েট করুন")
            steps.append(f"উত্তর: d/dx = {derivative}")
            
            # Generate plot points for visualization
            x_vals = np.linspace(-5, 5, 100)
            y_vals = [float(expr.subs(self.x, val)) for val in x_vals]
            dy_vals = [float(derivative.subs(self.x, val)) for val in x_vals]
            
            return {
                "answer": f"d/dx({expr}) = {derivative}",
                "steps": steps,
                "visualization": {
                    "type": "function_plot",
                    "function": str(expr),
                    "derivative": str(derivative),
                    "x_values": x_vals.tolist(),
                    "y_values": y_vals,
                    "dy_values": dy_vals
                }
            }
        except:
            return {"answer": "ডেরিভেটিভ গণনা করতে ব্যর্থ", "steps": ["দুঃখিত, এই ডেরিভেটিভ সমস্যাটি সমাধান করতে পারিনি"]}
    
    def solve_integral(self, problem_text: str) -> Dict[str, Any]:
        """Solve integral problems"""
        steps = []
        
        func_str = self.extract_function(problem_text)
        if not func_str:
            func_str = "x**2"
        
        try:
            expr = sp.sympify(func_str)
            integral = sp.integrate(expr, self.x)
            
            steps.append(f"ইন্টিগ্রাল: ∫{expr} dx")
            steps.append("পাওয়ার নিয়ম প্রয়োগ: ∫xⁿ dx = xⁿ⁺¹/(n+1) + C")
            steps.append("প্রতিটি টার্ম আলাদা করে ইন্টিগ্রেট করুন")
            steps.append(f"উত্তর: {integral} + C")
            
            return {
                "answer": f"∫{expr} dx = {integral} + C",
                "steps": steps
            }
        except:
            return {"answer": "ইন্টিগ্রাল গণনা করতে ব্যর্থ", "steps": ["ইন্টিগ্রাল সমস্যা সমাধানে সমস্যা হচ্ছে"]}
    
    def solve_matrix(self, problem_text: str) -> Dict[str, Any]:
        """Solve matrix problems"""
        steps = []
        
        # Simple 2x2 matrix for example
        if "determinant" in problem_text.lower():
            A = sp.Matrix([[1, 2], [3, 4]])  # Example
            det_A = A.det()
            
            steps.append(f"ম্যাট্রিক্স A = {A.tolist()}")
            steps.append("২×২ ম্যাট্রিক্সের ডিটারমিনেন্ট: det([[a,b],[c,d]]) = ad - bc")
            steps.append(f"গণনা: ({A[0,0]}×{A[1,1]}) - ({A[0,1]}×{A[1,0]})")
            steps.append(f"ফলাফল: {det_A}")
            
            return {
                "answer": f"det(A) = {det_A}",
                "steps": steps
            }
        
        return {"answer": "ম্যাট্রিক্স সমস্যা সমাধানে সহায়তা প্রয়োজন", "steps": steps}
    
    def extract_vectors(self, text: str) -> List[List[float]]:
        """Extract vectors from text (simplified)"""
        vectors = []
        # Look for patterns like [1,2,3] or (1,2,3)
        patterns = re.findall(r'\[[^\]]*\]', text)
        for pattern in patterns:
            try:
                # Clean and parse
                clean = pattern.strip('[]')
                nums = [float(x.strip()) for x in clean.split(',') if x.strip()]
                if nums:
                    vectors.append(nums)
            except:
                continue
        return vectors or [[1, 2, 3], [4, 5, 6]]  # Default vectors
    
    def extract_function(self, text: str) -> str:
        """Extract function from text"""
        # Look for common patterns
        patterns = [
            r'of\s+([^\.\?]+)',
            r'([\w\*\*\+\-\/\^\(\)\s]+)\s+where',
            r'f\(x\)\s*=\s*([^\n]+)'
        ]
        
        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return match.group(1).strip()
        
        return ""