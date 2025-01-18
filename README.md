
## Connect to EC2 Using SSM

Start an SSM session:
<img width="1840" alt="image" src="https://github.com/user-attachments/assets/626ee9b1-6974-4a47-9201-6c4bf2a5bb5e" />

Locally:
[Installation](https://docs.aws.amazon.com/systems-manager/latest/userguide/install-plugin-macos-overview.html#install-plugin-macos-signed)

```bash
aws ssm start-session --target <SSMTestInstanceID> --profile chunlin_default --region ap-southeast-1 --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters host="<RDSInstanceEndpoint>",portNumber="5432",localPortNumber="9000"
```

[Reference](https://aws.amazon.com/blogs/database/securely-connect-to-an-amazon-rds-or-amazon-ec2-database-instance-remotely-with-your-preferred-gui/)

## Install psql

```bash
sudo yum update -y

sudo yum search "postgres"

sudo yum install postgresql16
```

## Connect to RDS

From within the SSM session, use psql to connect to the database:
```bash
psql --host=<RDSInstanceEndpoint> --username=hsr_db_superuser --dbname=postgres
```

To list all tables:
```sql
\dt
```

To exit the psql command-line interface, simply type:

```sql
\q
```

This will quit the PostgreSQL session and return us to our shell or terminal.

## Install pgvector

```
CREATE EXTENSION vector;

SELECT typname FROM pg_type WHERE typname = 'vector';
```

```python
import json
import torch
import numpy as np
from transformers import AutoTokenizer, AutoModel

# Load your Hugging Face model
model_name = 'distilbert-base-uncased'  # Example model; replace with your choice
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModel.from_pretrained(model_name)

# Function to generate embedding for a single text
def generate_embedding(text):
    # Tokenize the input text
    inputs = tokenizer(text, return_tensors='pt', truncation=True, padding=True)
    
    # Perform a forward pass to get embeddings
    with torch.no_grad():
        outputs = model(**inputs)
        embeddings = outputs.last_hidden_state.mean(dim=1)  # Average the token embeddings
    
    return embeddings.squeeze().numpy()  # Convert to numpy array

# Function to generate INSERT INTO statements with vectors
def generate_insert_statements(data):
    # Initialize list to store SQL statements
    insert_statements = []

    for record in data:
        # Extracting text and id from the record
        id = record.get('id')
        text = record.get('text')

        # Generate the embedding for the text
        embedding = generate_embedding(text)
        
        # Convert the embedding to a list
        embedding_list = embedding.tolist()
        
        # Create the SQL INSERT INTO statement
        sql_statement = f"""
        INSERT INTO embeddings (id, vector, text)
        VALUES ('{id}', ARRAY{embedding_list}, '{text}')
        ON CONFLICT (id) DO UPDATE
        SET vector = EXCLUDED.vector, text = EXCLUDED.text;
        """
        
        # Append the statement to the list
        insert_statements.append(sql_statement)

    return insert_statements

# Example data
data = [
    {"id": "1", "text": "This is a sample text."},
    {"id": "2", "text": "Another example text for embedding."},
    {"id": "3", "text": "Yet another piece of text."}
]

# Generate the INSERT INTO statements
insert_statements = generate_insert_statements(data)

# Print out the generated SQL statements
for statement in insert_statements:
    print(statement)

```

## Screenshots

<img width="1840" alt="image" src="https://github.com/user-attachments/assets/e2848531-9e47-4142-82f4-4e264229cc55" />

<img width="1840" alt="image" src="https://github.com/user-attachments/assets/8123081a-7cb0-43e0-abdf-48a8f1297294" />

```bash
aws rds describe-db-engine-versions --default-only --engine postgres --profile chunlin_default --region ap-southeast-1
```
<img width="1837" alt="image" src="https://github.com/user-attachments/assets/9554ed44-21eb-4fe5-bb02-008346b20ca1" />

<img width="1840" alt="image" src="https://github.com/user-attachments/assets/6f910a95-b401-4f5d-8ce6-f5f7bf88413d" />
