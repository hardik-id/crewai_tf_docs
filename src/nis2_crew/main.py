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
os.environ["AZURE_OPENAI_DEPLOYMENT"] = "gpt-4o"
os.environ["OPENAI_API_VERSION"] = "2023-12-01-preview"
os.environ["AZURE_OPENAI_ENDPOINT"] = "https://aistudiotest1210172499.openai.azure.com/"
os.environ["AZURE_OPENAI_API_KEY"] = "30d65fe0b7e84f809b686a3fa77ff0cd"

os.environ["SERPER_API_KEY"] = "300075c4fcdf1f153881e98207221f77b5ada3bf"

azure_llm = AzureChatOpenAI(
    azure_endpoint=os.environ["AZURE_OPENAI_ENDPOINT"],
    api_key=os.environ["AZURE_OPENAI_API_KEY"],
    # api_version=os.environ.get("AZURE_OPENAI_VERSION"),
    model=os.environ["AZURE_OPENAI_DEPLOYMENT"],
)

# Instantiate tools
docs_tool = DirectoryReadTool(directory='./presentations')
file_tool = FileReadTool()
search_tool = SerperDevTool()
web_rag_tool =  WebsiteSearchTool(
    config=dict(
        llm=dict(
            provider="azure_openai", # or google, openai, anthropic, llama2, ...
            config=dict(
                model="gpt-4o",
            ),
        ),
        embedder=dict(
            provider="azure_openai", # or openai, ollama, ...
            config=dict(
                model="text-embedding-ada-002",
                deployment_name="text-embedding-ada-002",
            ),
        ),
    )
)
# Define the NIS 2 Researcher Agent
researcher = Agent(
    role='NIS 2 Research Analyst',
    goal='Analyze research findings on the NIS 2 Directive and extract key insights.',
    backstory='An expert in NIS 2 regulation, specializing in cybersecurity directives and policies.',
    llm=azure_llm,
    tools=[search_tool,web_rag_tool],  # No special tools here, just research
    verbose=True
)
# Define the Presentation Specialist Agent
presentation_specialist = Agent(
    role='Presentation Designer',
    goal='Transform research findings into a professional PowerPoint presentation',
    backstory='An experienced presentation designer with a keen eye for creating visually appealing and informative slides.',
    llm=azure_llm,
    tools=[docs_tool, file_tool],  # Tools for reading and processing document
    verbose=True
)

# Task for the Researcher
research_task = Task(
    description='Review research findings on a specific aspect of the NIS 2 Directive and summarize the key takeaways.',
    expected_output='A summary of the most important points and insights related to the NIS 2 Directive for cybersecurity professionals.',
    agent=researcher
)

# Task for the Presentation Specialist
presentation_task = Task(
    description='Create a PowerPoint presentation based on the research findings, with clear headlines, bullet points, and relevant visuals.',
    expected_output='A PowerPoint file with engaging and informative slides on NIS 2 regulation, suitable for cybersecurity professionals.',
    agent=presentation_specialist,
    output_file='presentations/nis2_presentation.md'  # The final presentation file will be saved here
)


# Assemble a crew with planning enabled
crew = Crew(
    agents=[researcher, presentation_specialist],
    tasks=[research_task, presentation_task],
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

# Kick off the process with specific inputs (e.g., the aspect of NIS 2 to focus on)
result = crew.kickoff(inputs={'aspect': 'NIS 2 Directive - Incident Reporting'})
print(result)
