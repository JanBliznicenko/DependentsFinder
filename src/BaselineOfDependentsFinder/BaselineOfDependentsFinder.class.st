Class {
	#name : 'BaselineOfDependentsFinder',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfDependentsFinder',
	#package : 'BaselineOfDependentsFinder'
}

{ #category : 'baselines' }
BaselineOfDependentsFinder >> baseline: spec [

	<baseline>
	spec for: #common do: [
			spec
				package: 'DependentsFinder';
				group: 'default' with: #( 'DependentsFinder' ) ]
]
