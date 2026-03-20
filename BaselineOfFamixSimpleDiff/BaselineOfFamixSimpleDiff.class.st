"
This is the baseline for Clap - the Pharo command line handler
"
Class {
	#name : 'BaselineOfFamixSimpleDiff',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfFamixSimpleDiff',
	#package : 'BaselineOfFamixSimpleDiff'
}

{ #category : 'baselines' }
BaselineOfFamixSimpleDiff >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			package: 'Famix-Simple-Diff';
			group: 'default' with: #( Famix-Simple-Diff ) ]
]
