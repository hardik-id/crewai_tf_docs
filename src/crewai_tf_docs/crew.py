from crewai import Agent, Crew, Process, Task
from crewai.project import CrewBase, agent, crew, task, llm

# Uncomment the following line to use an example of a custom tool
# from crewai_tf_docs.tools.custom_tool import MyCustomTool

# Check our tools documentations for more information on how to use them
# from crewai_tools import SerperDevTool
import os
os.environ["AZURE_AI_API_KEY"] = "3332df6d0840401e9c95e7fe30e0be88"
os.environ["AZURE_AI_API_BASE"] = "https://crewai-hub-ai-services.openai.azure.com/openai/deployments/gpt-4o/chat/completions?api-version=2023-03-15-preview"

@CrewBase
class CrewaiTfDocsCrew():
	"""CrewaiTfDocs crew"""
	agents_config = 'config/agents.yaml'
	tasks_config = 'config/tasks.yaml'
	llm='azure/gpt-4o'

	@agent
	def researcher(self) -> Agent:
		return Agent(
			config=self.agents_config['researcher'],
			# tools=[MyCustomTool()], # Example of custom tool, loaded on the beginning of file
			verbose=True
		)

	@agent
	def reporting_analyst(self) -> Agent:
		return Agent(
			config=self.agents_config['reporting_analyst'],
			verbose=True
		)

	@task
	def research_task(self) -> Task:
		return Task(
			config=self.tasks_config['research_task'],
		)

	@task
	def reporting_task(self) -> Task:
		return Task(
			config=self.tasks_config['reporting_task'],
			output_file='report.md'
		)

	@crew
	def crew(self) -> Crew:
		"""Creates the CrewaiTfDocs crew"""
		return Crew(
			agents=self.agents, # Automatically created by the @agent decorator
			tasks=self.tasks, # Automatically created by the @task decorator
			process=Process.sequential,
			verbose=True,
			# process=Process.hierarchical, # In case you wanna use that instead https://docs.crewai.com/how-to/Hierarchical/
		)