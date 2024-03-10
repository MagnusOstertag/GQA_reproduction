# GQA reproduction

I have created two jupyter notebooks, one for reproducing the dataset balancing (`balancing.ipynb`) and one for the figures (`figures.ipynb`). The main findings are described below and for most of figure reproduction results I also provide bash-scripts to check and plausibilize the results of the notebook. The referenced version is [version 3 on arxiv](https://arxiv.org/abs/1902.09506).

## usage

Use `download.sh` to get the `GQA` dataset. Using version 1.1 for this repo, as afterwards only further splits were added (which do not include the meta-data necessary for this analysis).
And `pip install -r requirements.txt` to install the necessary packages, e.g. in a conda environment `conda create --prefix ./conda python=3.12` (tested with `python 3.12`).

## figures

1. sunburst diagram of the first question words (fig. 7, supplemental): a qualitatively and quantitatively different diagram
    * e.g. questions continuing "Are" with "the" instead of only "there"
        * check with `jq '.[] | select(.question | startswith("Are the "))' testdev_balanced_questions.json`
2. table comparing `VQA 2.0` and `GQA` (tab. 3, supplemental): quantitatively different, but `VQA 2.0` only has a sum of the probabilites of $50 \%$
    * e.g. 19% short questions
        * check with %TODO
3. pie diagrams of the structural or semantic types, semantic steps (fig. 6, main paper): qualitatively and quantitatively different diagrams
    * e.g. for the semantic type `relate` a share of 46.5% instead of 52%.
        * echk with %TODO
    * it's unclear how the semantic length is derived, defined as number of computation steps to arrive at the answer. It does not look like the length of the `semantic` field
4. table of the function catalog (tab. 2, supplemental): the combinations of semantic and structural types are different getting the unique combinations of semantic and structural 
    * e.g. `compare` <-> `attr` in the table, but in the data
        * check with %TODO
    * e.g. no `compare` to `object` in the data?
        * check with %TODO
    * also, in the header semantic and structural seems to be switched
5. stacked bar visualization of the balancing (fig. 10, supplemental): different ranking and other significat differences for all but the upper left figure
    * no `car_modernity` (only `car_modern`) and `ground_table` in the data
        * check with %TODO
    * GQA before balancing, local: e.g. for `man`, `car_modern`, and a lot of other labels.
    * e.g. "no" as the only answer for questions of answer type "man", making balancing impossible
        * check with `for file in {*_questions.json,train_all_questions/*questions_*.json}; do echo "File:$file"; jq -c 'map(select(.groups.local? == "03-man") | .answer) | unique' "$file"; echo; done`

## balancing

After the balancing is done, two further downsampling steps are executed, which balance based on the `groups` and reject too similar questions.

1. the differences found with reproducing the balancing figures (see last bullet point)
2. the bounds on the parameters ($b$, $r_{min}$, $r_{max}$) for the balancing downsampling can't be reconstructed. Probably signifying that the downsampling based on their type and a filtering out of redundant questions after the balancing does significantly alter the properties.
    * notably, the relative frequency-based answer ranking after the whole balancing process

## compounding factors for the differences

* the split might change some properties
    * not possible for `figures:1.`, `figures:4.`
* the downsampling after the balancing significantly changes the properties of the balancing

## Cite

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
