FROM pytorch/pytorch:latest

ENV PIP_ROOT_USER_ACTION=ignore

WORKDIR /venv

COPY clean_layer.sh  /tmp/clean_layer.sh
RUN chmod +x /tmp/clean_layer.sh

RUN apt-get update \ 
    && apt-get install -y wget libfontconfig1 libxrender1 libxext6\
    && rm -rf /var/lib/apt/lists/*

# Add conda-forge
RUN wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh" \ 
    && bash Miniforge3-Linux-x86_64.sh -b \
    && rm -f Miniforge3-Linux-x86_64.sh

RUN pip install --upgrade pip \
    && pip install opencv-python 

RUN conda config --add channels nvidia && \
    conda config --add channels rapidsai && \
    conda config --add channels conda-forge && \
    conda update --all -y

COPY base_requirements.txt base_requirements.txt
RUN conda install --yes --file base_requirements.txt 

# some conflicts occur when those packages are added in the base_requirements and slows down installation
RUN pip install transformers timm albumentations accelerate
RUN python -m spacy download en_core_web_sm && python -m spacy download en_core_web_lg && \
    apt-get update && apt-get install -y ffmpeg && \
    /tmp/clean_layer.sh

# Tesseract and some associated utility packages
RUN apt-get install tesseract-ocr -y && \
    pip install pytesseract \
        pdf2image \
        PyPDF && \
    /tmp/clean_layer.sh

ENV TESSERACT_PATH=/usr/bin/tesseract

EXPOSE 8888

ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]

