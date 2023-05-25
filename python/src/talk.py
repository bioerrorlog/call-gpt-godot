import sys
from langchain.chat_models import ChatOpenAI
from langchain.schema import (
    HumanMessage,
)


user_text = sys.argv[1]
api_key = sys.argv[2]

chat = ChatOpenAI(temperature=1, openai_api_key=api_key)
response = chat([HumanMessage(content=user_text)])

print(response.content)
