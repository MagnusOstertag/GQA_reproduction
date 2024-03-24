mkdir -p ver1.2
cd ver1.2
wget https://downloads.cs.stanford.edu/nlp/data/gqa/questions1.2.zip
unzip questions1.2.zip
cd ..

git clone git@github.com:dorarad/gqa.git
cd gqa
touch __init__.py
cd evaluation
touch __init__.py
cd ..
