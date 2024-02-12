# Python image
FROM python:3.10-slim

# Set the working directory to /app
WORKDIR /app

# Install pytorch and cuda support
RUN pip install torch==2.0.0+cu117 torchvision==0.15.1+cu117 torchaudio==2.0.1 --index-url https://download.pytorch.org/whl/cu117

# Install torch-sparse
RUN pip install torch-scatter torch-sparse -f https://data.pyg.org/whl/torch-2.0.0+cu117.html

# # Install build dependencies and 'gcc'
# RUN apt-get update && apt-get install -y build-essential gcc

# Install git
RUN apt-get update && apt-get install -y git

# Install Sent2Vec dependencies (FastText)
RUN apt-get update && apt-get install -y build-essential cmake unzip
RUN git clone https://github.com/facebookresearch/fastText.git /app/fastText
WORKDIR /app/fastText
RUN mkdir build && cd build && cmake .. && make && make install

# Create a directory for sent2vec and copy the repository
# RUN mkdir /app/sent2vec
COPY ./sent2vec /app/sent2vec

# Set the PYTHONPATH environment variable to include the /app/ directory
ENV PYTHONPATH="/app:${PYTHONPATH}"

# Install Sent2vec library using setup.py
WORKDIR /app/sent2vec
# COPY ./src /app/sent2vec/src/
# COPY ./Makefile /app/sent2vec/Makefile
# COPY ./requirements.txt /app/sent2vec/requirements.txt
# COPY ./setup.py /app/sent2vec/setup.py
RUN pip install .

# Copy JSON and JSONL files into the container
COPY citation_network.json /app/citation_network.json
COPY data_path.json /app/data_path.json
COPY dev.jsonl /app/dev.jsonl
COPY hyperparams.json /app/hyperparams.json
COPY label_tree.json /app/label_tree.json
COPY label_vocab.json /app/label_vocab.json
COPY schemas.json /app/schemas.json
COPY secs.jsonl /app/secs.jsonl
COPY test.jsonl /app/test.jsonl
COPY train.jsonl /app/train.jsonl
COPY type_map.json /app/type_map.json

# Copy the Python code files into the container
COPY ./model.py /app/model.py
COPY ./basicmodules.py /app/basicmodules.py
COPY ./data_helper.py /app/data_helper.py
COPY ./helper.py /app/helper.py
COPY ./submodules.py /app/submodules.py
COPY ./run.py /app/run.py

# Copy the pre-trained model into the container
COPY best_model.pt /app/best_model.pt

# Copy ils2v.bin into the container
COPY ils2v.bin /app/data/ils2v.bin

# Copy the requirement.txt file into the container
COPY requirement.txt /app/requirement.txt

# Install Python dependencies from requirements.txt
RUN pip install -r /app/requirement.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV Name World

# Set the working directory to /app
WORKDIR /app

# Run app.py when the container launches
CMD [ "python", "run.py" ]