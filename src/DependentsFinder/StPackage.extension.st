Extension { #name : 'StPackage' }

{ #category : '*DependentsFinder' }
StPackage >> allDependencies [

	^ self dependencies flatCollect: [ :each | each allDependencies ]
]
