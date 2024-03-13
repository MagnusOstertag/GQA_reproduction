# GQA reproduction

I have created two jupyter notebooks, one for reproducing the dataset balancing (`balancing.ipynb`) and one for the figures (`figures.ipynb`). The main findings are described below and for most of figure reproduction results I also provide bash-scripts to check and plausibilize the results of the notebook. The referenced version is [version 3 on arxiv](https://arxiv.org/abs/1902.09506).

## usage

Use `download.sh` to get the `GQA` dataset. Using version 1.1 for this repo, as afterwards only further splits were added (which do not include the meta-data necessary for this analysis).
And `pip install -r requirements.txt` to install the necessary packages, e.g. in a conda environment `conda create --prefix ./conda python=3.12` (tested with `python 3.12`).

## figures

Following the order of the figures in the supplemental:

1. sunburst diagram of the first question words (fig. 7, supplemental): a qualitatively and quantitatively different diagram
    * there are questions continuing `Are` with `the` instead of only `there`
        * check with `jq '.[] | select(.question | startswith("Are the "))' testdev_balanced_questions.json`
    * `what is the` more often followed by `color` instead of `man`
        * `for file in {train_balanced_questions.json,val_balanced_questions.json,testdev_balanced_questions.json}; do echo "File:$file"; jq '[.[] | select(.question | startswith("What is the color "))] | length' "$file"; echo; done` -> sum: $13055$
        * `for file in {train_balanced_questions.json,val_balanced_questions.json,testdev_balanced_questions.json}; do echo "File:$file"; jq '[.[] | select(.question | startswith("What is the man "))] | length' "$file"; echo; done` -> $9690$
    * `is` is followed much more often by `the` instead of `there`
        * `jq '[.[] | select(.question | startswith("Is the "))] | length' train_balanced_questions.json` -> $160065$
        * `jq '[.[] | select(.question | startswith("Is there "))] | length' train_balanced_questions.json` -> $36805$
    * there are (many) questions starting with `On which`
        * `jq '.[] | select(.question | startswith("On which "))' testdev_balanced_questions.json`
        * `jq '[.[] | select(.question | startswith("On which "))] | length' train_balanced_questions.json` -> $36280$
2. pie diagrams of the structural or semantic types, semantic steps (fig. 8, supplemental and fig. 6, main paper): qualitatively and quantitatively different diagrams
    * e.g. for the semantic type `relate` a share of $46.5%$ instead of $52%$, of `attribute` $31.9%$ instead of $28%$
        * total: `for file in {*balanced_questions.json,}; do echo "File:$file"; jq '[.[] | keys | length] | add' "$file"; echo; done` -> sum: $1087640$
        * `for file in {*balanced_questions.json,}; do echo "File:$file"; jq '[.[] | select(.types.semantic? == "rel")] | length' "$file"; echo; done` -> sum: $505906$, ratio: $46.5\%$
        * `for file in {*balanced_questions.json,}; do echo "File:$file"; jq '[.[] | select(.types.semantic? == "attr")] | length' "$file"; echo; done` -> sum: $347716$, ratio: $31.9\%$
3. table of the function catalog (tab. 2, supplemental, partly fig. 7 top right, supplemental): the combinations of semantic and structural types are different getting the unique combinations of semantic and structural 
    * e.g. no `compare` <-> `attr` in the table, but in the data
        * check with `jq '[.[] | select(.types.structural == "compare" and .types.semantic == "attr")] | length' testdev_balanced_questions.json` -> $589$
    * e.g. no `compare` to `object` in the data?
        * check heuristically with `jq '.[] | select(.types.structural == "compare" and .types.semantic == "obj")' train_balanced_questions.json`
    * the combinations of `semantic` and `structural` are very different from the data
        * `jq '[.[] | {semantic: .types.semantic, structural: .types.structural}] | unique' train_balanced_questions.json`
    * how are the question types derived? As they seem not to be `types:detailed`, but there is no other field applicable
    * also, in the header semantic and structural seem to be switched
4. stacked bar visualization of the balancing (fig. 10, supplemental and fig. 5, main paper): different ranking and other significat differences for all but the upper left figure
    * no `car_modernity` (only `car_modern`) or `ground_type` in the data
        * check with `for file in {*_questions.json,train_all_questions/*questions_*.json}; do echo "File:$file"; jq 'map(select(.groups.local? | type=="string" and contains("car_modernity")))' "$file"; echo; done`
        * check with `for file in {*_questions.json,train_all_questions/*questions_*.json}; do echo "File:$file"; jq 'map(select(.groups.local? | type=="string" and contains("ground_type")))' "$file"; echo; done`
    * GQA before balancing, local: the ranking is very different e.g. for `floor_cleanliness` > `car_vposition` (after balancing):
        * `for file in {train_balanced_questions.json,val_balanced_questions.json,testdev_balanced_questions.json}; do echo "File:$file"; jq 'map(select(.groups.local? | type=="string" and contains("floor_cleanliness")) | .answer) | group_by(.) | map({key: .[0], value: length})' "$file"; echo; done` -> "dirty": $76$, "clean": $38$, "stained": $5$, $63.9 \%$ top answer
        * `for file in {train_balanced_questions.json,val_balanced_questions.json,testdev_balanced_questions.json}; do echo "File:$file"; jq 'map(select(.groups.local? | type=="string" and contains("car_vposition")) | .answer) | group_by(.) | map({key: .[0], value: length})' "$file"; echo; done` -> "bottom": $461$, "top": $363$, $55.9 \%$ top answer
    * e.g. `no` as the only answer for questions of answer type "man", making balancing impossible
        * check with `for file in {*_questions.json,train_all_questions/*questions_*.json}; do echo "File:$file"; jq -c 'map(select(.groups.local? == "03-man") | .answer) | unique' "$file"; echo; done` -> in `testdev_all_questions.json`, `val_{all, balanced}_questions.json`, `train_all_questions_{0-9}.json`
5. pie chart of the question semantic steps (fig. 13, supplemental and partly fig. 6 main paper)
    * how is the semantic length is derived (defined as number of computation steps to arrive at the answer). It does not look like the length of the `semantic` field
    * e.g. there are no questions with 1 reasoning step
        * check heuristically with `jq '[.[] | select(.semantic | length == 1)] | length' train_balanced_questions.json`
6. table comparing `VQA 2.0` and `GQA` (tab. 3, supplemental): quantitatively different, but `VQA 2.0` only has a sum of the probabilites of $50 \%$
    * e.g. the question length are different
        * check heuristically with `jq '[.[] | .question | split(" ") | length] | add / length' train_balanced_questions.json` -> $8.76$
    * e.g. much less `logical questions` found
        * check with `for file in {*balanced_questions.json,}; do echo "File:$file"; jq '[.[] | select(.types.structural? == "logical")] | length' "$file"; echo; done` -> sum: $131928$, ratio: $12.1\%$
    * what does the compositional question mean?
    * is `spatial` actually `verify`?

## balancing

After the balancing is done, two further downsampling steps are executed, which balance based on the `groups` and reject too similar questions.

1. the differences found when reproducing the balancing figures (see figures:4.)
2. the bounds on the parameters ($b$, $r_{min}$, $r_{max}$) for the balancing downsampling can't be reconstructed. 
3. the relative frequency-based answer ranking after the whole balancing process does not reflect the biases in the big GQA dataset ("This ensures that the relative frequency-based answer ranking stays the same." ~ p. 6)
    * e.g. for the `local question group` named `table_on` the sampling from all the questions is very strange: `cake` is very seldomly taken, whereas `glass` is now frequently in the balanced dataset
        * `cake` in balanced: `for file in {train_balanced_questions.json,val_balanced_questions.json,testdev_balanced_questions.json}; do echo "File:$file"; jq '[.[] | select(.groups.local? | type=="string" and contains("table_on,")) | select(.answer == "cake")] | length' "$file"; echo; done` -> sum: 23
        * whereas in all: `for file in {testdev_all_questions.json,val_all_questions.json,train_all_questions/*questions_*.json}; do echo "File:$file"; jq '[.[] | select(.groups.local? | type=="string" and contains("table_on,")) | select(.answer == "cake")] | length' "$file"; echo; done` -> sum: 414
        * `glass` in balanced: `for file in {train_balanced_questions.json,val_balanced_questions.json,testdev_balanced_questions.json}; do echo "File:$file"; jq '[.[] | select(.groups.local? | type=="string" and contains("table_on,")) | select(.answer == "glass")] | length' "$file"; echo; done` -> sum: 146
        * whereas in all: `for file in {testdev_all_questions.json,val_all_questions.json,train_all_questions/*questions_*.json}; do echo "File:$file"; jq '[.[] | select(.groups.local? | type=="string" and contains("table_on,")) | select(.answer == "glass")] | length' "$file"; echo; done` -> sum: 239

Probably this means that the downsampling based on their type and a filtering out of redundant questions after the balancing does significantly alter the properties.

## compounding factors for the differences

* the split might change some properties
* the downsampling after the balancing could significantly changes the properties of the balancing
* for the `structural type` in the changelog: "- 1.1: Updating the questions' functional programs. Fixing some typos." (ReadMe_questions)

## cite

```
@misc{hudson2019gqa,
      title={GQA: A New Dataset for Real-World Visual Reasoning and Compositional Question Answering}, 
      author={Drew A. Hudson and Christopher D. Manning},
      year={2019},
      eprint={1902.09506},
      archivePrefix={arXiv},
      primaryClass={cs.CL}
}
```
