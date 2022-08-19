FROM nvidia/cuda:10.2-runtime-ubuntu18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

# Install Dependencies of Miniconda
RUN apt-get update && \
    apt-get install -y wget libsndfile1 ffmpeg build-essential && \
    rm -rf /var/lib/apt/lists/* 

# Install miniconda3
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

RUN conda update -n base -c defaults conda && \
    conda install -c conda-forge montreal-forced-aligner && \
    ln -s /usr/lib/x86_64-linux-gnu/libffi.so.6 /usr/lib/x86_64-linux-gnu/libffi.so.7

RUN pip install -v boto3 jamo nltk pydub scipy python-dotenv


CMD ["sh", "run_preprocess.sh"]
