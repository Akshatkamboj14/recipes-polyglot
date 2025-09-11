import os
import requests
import boto3
from botocore.exceptions import ClientError
from dotenv import dotenv_values
from flask import Flask, request, jsonify
from langchain_community.llms import Bedrock
from langchain.prompts import PromptTemplate
from langchain.chains import LLMChain
from flask_cors import CORS

# Load environment variables from .env file
env_vars = dotenv_values(".env")

app = Flask(__name__)
CORS(app) # This will enable CORS for all routes

# --- Configuration ---
NUTRITIONX_API_URL = env_vars.get("NUTRITIONX_API_URL")
NUTRITIONX_API_KEY = env_vars.get("NUTRITIONX_API_KEY")
NUTRITIONX_APP_ID = env_vars.get("NUTRITIONX_APP_ID")

# --- LangChain Setup ---
# Get AWS credentials from the loaded .env dictionary
aws_access_key_id = env_vars.get("AWS_ACCESS_KEY_ID")
aws_secret_access_key = env_vars.get("AWS_SECRET_ACCESS_KEY")
aws_region = env_vars.get("AWS_REGION", "us-east-1")

llm = None
try:
    if not aws_access_key_id or not aws_secret_access_key:
        print("AWS credentials not found in .env file. Please check your configuration.")
    else:
        # Manually create a boto3 session and client to bypass validation issues
        session = boto3.Session(
            aws_access_key_id=aws_access_key_id,
            aws_secret_access_key=aws_secret_access_key,
            region_name=aws_region
        )
        boto3_client = session.client("bedrock-runtime")

        # Initialize the Bedrock LLM with the manually created client
        llm = Bedrock(
            client=boto3_client,
            model_id="anthropic.claude-v2"
        )
except ClientError as e:
    # Catches specific authentication or permission errors from the AWS service
    print(f"Error initializing Bedrock LLM: {e}")
except Exception as e:
    # Catches any other unexpected errors during initialization
    print(f"An unexpected error occurred: {e}")

# Prompt for extracting ingredients from a recipe
ingredient_extraction_prompt = PromptTemplate(
    input_variables=["recipe_text"],
    template="""Extract a list of all ingredients from the following recipe text.
    Please format the output as a simple, comma-separated list.
    If no ingredients are found, return an empty string.

    Recipe:
    {recipe_text}

    Ingredients:"""
)

# Create a simple chain
ingredient_chain = LLMChain(llm=llm, prompt=ingredient_extraction_prompt)


# --- API Endpoint ---
@app.route('/analyze-nutrition', methods=['POST'])
def analyze_nutrition():
    """
    Analyzes the nutritional content of a recipe.
    Expects a JSON body with a 'recipe' key containing the recipe text.
    """
    if not request.json or 'recipe' not in request.json:
        return jsonify({"error": "Missing 'recipe' key in request body"}), 400

    recipe_text = request.json['recipe']

    if not llm:
        return jsonify({"error": "LLM not initialized, check AWS configuration."}), 500

    try:
        # Step 1: Use LangChain to extract ingredients
        extracted_ingredients_str = ingredient_chain.run(recipe_text=recipe_text)
        ingredients_list = [ingredient.strip() for ingredient in extracted_ingredients_str.split(',') if ingredient.strip()]

        if not ingredients_list:
            return jsonify({"message": "No ingredients could be extracted from the recipe."}), 200

        # Step 2: Call the NutritionX API for analysis
        headers = {
            "Content-Type": "application/json",
            "x-app-id": NUTRITIONX_APP_ID,
            "x-app-key": NUTRITIONX_API_KEY
        }
        data = {
            "query": " and ".join(ingredients_list)
        }
        
        response = requests.post(NUTRITIONX_API_URL, headers=headers, json=data)
        
        if response.status_code != 200:
            return jsonify({"error": "Failed to get nutrition data from API.", "details": response.json()}), response.status_code

        nutrition_data = response.json()
        
        return jsonify(nutrition_data), 200

    except Exception as e:
        app.logger.error(f"An error occurred: {e}", exc_info=True)
        return jsonify({"error": "An internal error occurred."}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

