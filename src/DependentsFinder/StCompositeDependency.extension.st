Extension { #name : 'StCompositeDependency' }

{ #category : '*DependentsFinder' }
StCompositeDependency >> allDependencies [

	^ self dependencies flatCollect: [ :each | each allDependencies ]
]

{ #category : '*DependentsFinder' }
StCompositeDependency >> sourcePackages [

	^ self dependencies flatCollectAsSet: [ :each | each sourcePackages ]
]

{ #category : '*DependentsFinder' }
StCompositeDependency >> targetPackages [

	^ self dependencies flatCollectAsSet: [ :each | each targetPackages ]
]
