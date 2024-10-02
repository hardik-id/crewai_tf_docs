import os

from crewai import Agent, Task, Crew
from crewai_tools import (
    DirectoryReadTool,
    FileReadTool,
    SerperDevTool,
    WebsiteSearchTool
)
from dotenv import load_dotenv
from langchain_openai import AzureChatOpenAI

load_dotenv()

azure_llm = AzureChatOpenAI(
    azure_endpoint=os.environ["AZURE_OPENAI_ENDPOINT"],
    api_key=os.environ["AZURE_OPENAI_API_KEY"],
    # api_version=os.environ.get("AZURE_OPENAI_VERSION"),
    model=os.environ["AZURE_OPENAI_DEPLOYMENT"],
)
from datetime import datetime

# Create a timestamp for the file name
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

# Define the output file variable with a timestamp
improvement_output_file = f'terraform/terraform_code_improvements_{timestamp}.md'
docs_output_file = f'terraform/terraform_infrastructure_docs_{timestamp}.md'

# Instantiate tools
docs_tool = DirectoryReadTool(directory='./terraform')
file_tool = FileReadTool()
# search_tool = SerperDevTool()
# web_rag_tool = WebsiteSearchTool(
#     config=dict(
#         llm=dict(
#             provider="azure_openai",  # or google, openai, anthropic, llama2, ...
#             config=dict(
#                 model="gpt-4o",
#             ),
#         ),
#         embedder=dict(
#             provider="azure_openai",  # or openai, ollama, ...
#             config=dict(
#                 model="text-embedding-ada-002",
#                 deployment_name="text-embedding-ada-002",
#             ),
#         ),
#     )
# )

# Create the Terraform Reader Agent
terraform_reader = Agent(
    role='Terraform Code Analyzer',
    goal='Accurately analyze and interpret Terraform configuration files',
    backstory="""You are an expert in cloud infrastructure and Terraform. 
    Your job is to read Terraform files, understand their structure and purpose, 
    and extract key information about the infrastructure they define.""",
    verbose=True,
    llm=azure_llm,
    tools=[docs_tool, file_tool]
)

# Create the Documentation Writer Agent
doc_writer = Agent(
    role='Technical Documentation Specialist',
    goal='Create clear and comprehensive Markdown documentation for Terraform-defined infrastructure',
    backstory="""You are a skilled technical writer with extensive knowledge of cloud infrastructure. 
    Your expertise lies in translating complex technical configurations into easily understandable documentation.""",
    verbose=True,
    llm=azure_llm,
    tools=[docs_tool, file_tool],
)

# Create the Terraform Code Improvement Reviewer Agent
terraform_reviewer = Agent(
    role='Terraform Code Improvement Reviewer',
    goal='Analyze the Terraform code for potential improvements, optimizations, and best practices, and document these findings clearly in Markdown format.',
    backstory="""You are an expert Terraform developer with years of experience in cloud infrastructure. 
    Your specialty is reviewing Terraform code and configurations, identifying areas for improvement, and suggesting best practices. 
    You have a keen eye for efficiency, security, and maintainability in infrastructure-as-code.
    and provide clear documentation on the recommended changes.""",
    verbose=True,
    llm=azure_llm,
    tools=[docs_tool, file_tool],
)


# Task 1: Read and Analyze Terraform Files
analyze_task = Task(
    description="""
    1. Use the DirectoryReadTool to list all .tf files in the './terraform' directory.
    2. For each .tf file found:
       a. Use the FileReadTool to read its contents.
       b. Analyze the Terraform code to understand:
          - Resources being created
          - Variables and their purposes
          - Modules used and their configurations
          - Outputs defined
    3. Compile a summary of the infrastructure defined across all Terraform files.
    """,
    agent=terraform_reader,
    expected_output="A comprehensive summary of the Terraform-defined infrastructure, including resources, variables, modules, and outputs."
)

# Task 2: Create Documentation
document_task = Task(
    description="""
    Using the analysis provided by the Terraform Code Analyzer:
    1. Create a well-structured Markdown document that includes:
       a. An overview of the infrastructure
       b. Detailed sections for each major component (e.g., networking, compute, storage)
       c. Explanation of key variables and their impact
       d. Description of modules used and their purpose
       e. List of outputs and their significance
    2. Ensure the documentation is clear, concise, and follows best practices for technical writing.
    3. Use the FileWriterTool to save the Markdown content to 'terraform_infrastructure_docs.md' in the current directory.
    """,
    agent=doc_writer,
    expected_output="A comprehensive Markdown file documenting the Terraform infrastructure, saved as 'terraform/terraform_infrastructure_docs.md'.",
    output_file=docs_output_file
)

# Task 3: Review and Document Terraform Code Improvements
improvement_task = Task(
    description="""
    Using the Terraform code analysis provided by the Terraform Code Improvement Reviewer:
    1. Review each .tf file to identify potential improvements, such as:
       a. Performance optimizations
       b. Security enhancements (e.g., better access control, encryption, etc.)
       c. Code refactoring for maintainability and readability
       d. Following best practices for resource naming conventions and module use
       e. Reducing redundancy and promoting modularity
    2. Document the suggested improvements in a well-structured Markdown file, including:
       a. Description of each identified issue
       b. Explanation of why it needs improvement
       c. Recommended changes with rationale
    3. Use the FileWriterTool to save the Markdown content as 'terraform_code_improvements.md' in the current directory.
    """,
    agent=terraform_reviewer,
    expected_output="A comprehensive Markdown file documenting suggested improvements and optimizations, saved as 'terraform/terraform_code_improvements.md'.",
    output_file=improvement_output_file
)


# Assemble a crew with planning enabled
crew = Crew(
    agents=[terraform_reader, doc_writer, terraform_reviewer],
    tasks=[analyze_task, document_task, improvement_task],
    verbose=True,
    planning=True,  # Enable planning feature
    planning_llm=azure_llm,
    embedder={
        "provider": "azure_openai",
        "config": {
            "model": 'text-embedding-ada-002',
            "deployment_name": "text-embedding-ada-002"
        }
    }
)

# Execute tasks
crew.kickoff()
