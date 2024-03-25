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

mkdir -p vg14
cd vg14
# get the visual genome v1.4 dataset from https://homes.cs.washington.edu/~ranjay/visualgenome/api.html
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/readme_v1_4.txt
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/objects.json.zip
unzip objects.json.zip
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/relationships.json.zip
unzip relationships.json.zip
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/object_alias.txt
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/object_synsets.json.zip
unzip object_synsets.json.zip
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/attribute_synsets.json.zip
unzip attribute_synsets.json.zip
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/relationship_synsets.json.zip
unzip relationship_synsets.json.zip
# from version v1.2
wget https://cs.stanford.edu/people/rak248/VG_100K_2/images.zip
unzip images.zip
wget https://cs.stanford.edu/people/rak248/VG_100K_2/images2.zip
unzip images2.zip
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/image_data.json.zip
unzip image_data.json.zip
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/region_descriptions.json.zip
unzip region_descriptions.json.zip
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/question_answers.json.zip
unzip question_answers.json.zip
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/attributes.json.zip
unzip attributes.json.zip
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/region_graphs.json.zip
unzip region_graphs.json.zip
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/scene_graphs.json.zip
unzip scene_graphs.json.zip
wget https://homes.cs.washington.edu/~ranjay/visualgenome/data/dataset/qa_to_region_mapping.json.zip