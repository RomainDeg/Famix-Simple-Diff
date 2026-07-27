# Famix-Simple-Diff
Simple implementation to compare two models and return whether they are identical or not.
The tools also provide a list of differences that you can find between models.

## Baseline

```Smalltalk
Metacello new
  baseline: 'FamixSimpleDiff';
  repository: 'github://moosetechnology/Famix-Simple-Diff:main/src';
  load
```
## How to use Famix-Simple-Diff

```Smalltalk
model := '/path/to/my/model.json' asFileReference readStreamDo: [ :st | FamixJavaModel new importFromJSONStream: st ].

diff := FamixSimpleDiff new.

diff compareModel: victim to: model 
```
## How does it works ?
The tool will traverse all the entities of the model and uses the Moose meta-description to compare theirs type, relations.
