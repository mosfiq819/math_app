from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Dict, Any, Optional
import uvicorn
from math_solver import MathSolver
from ocr_processor import OCRProcessor
from ai_explainer import AIExplainer
import json

app = FastAPI(title="Bangla Math Solver API", version="1.0")

# CORS allow from mobile app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize components
math_solver = MathSolver()
ocr_processor = OCRProcessor()
ai_explainer = AIExplainer()

class MathProblem(BaseModel):
    problem_text: str
    problem_type: str = "auto"
    language: str = "en"

class SolutionResponse(BaseModel):
    success: bool
    answer: str
    steps: list
    visualization: Optional[Dict] = None
    error: Optional[str] = None

@app.get("/")
async def root():
    return {"message": "Bangla Math Solver API is running"}

@app.post("/solve", response_model=SolutionResponse)
async def solve_problem(problem: MathProblem):
    """Solve math problem from text"""
    try:
        result = math_solver.solve(problem.problem_text, problem.problem_type)
        
        # Generate AI explanation
        if result["steps"]:
            explained_steps = await ai_explainer.explain_steps(
                problem.problem_text,
                result["answer"],
                result["steps"],
                problem.language
            )
            result["steps"] = explained_steps
        
        return SolutionResponse(
            success=True,
            answer=result["answer"],
            steps=result["steps"],
            visualization=result.get("visualization")
        )
    except Exception as e:
        return SolutionResponse(
            success=False,
            answer="",
            steps=[],
            error=str(e)
        )

@app.post("/upload/image")
async def upload_image(file: UploadFile = File(...)):
    """Upload and process math problem image"""
    try:
        # Read image file
        contents = await file.read()
        
        # Process with OCR
        extracted_text = ocr_processor.process_image(contents)
        
        # Detect problem type
        problem_type = math_solver.detect_problem_type(extracted_text)
        
        return {
            "success": True,
            "extracted_text": extracted_text,
            "problem_type": problem_type
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/topics")
async def get_topics():
    """Get available math topics"""
    topics = {
        "vector_algebra": [
            "dot_product",
            "cross_product",
            "magnitude",
            "angle_between_vectors",
            "unit_vector"
        ],
        "linear_algebra": [
            "matrix_addition",
            "matrix_multiplication",
            "determinant",
            "inverse",
            "eigenvalues"
        ],
        "calculus": [
            "derivative",
            "integral",
            "limit",
            "taylor_series",
            "partial_derivative"
        ],
        "differential_equations": [
            "first_order",
            "second_order",
            "separable",
            "homogeneous"
        ]
    }
    return {"topics": topics}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)