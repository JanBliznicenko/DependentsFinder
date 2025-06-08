Extension { #name : 'Package' }

{ #category : '*DependentsFinder' }
Package >> threeWayCompareTo: anotherPackage [

	^ self name threeWayCompareTo: anotherPackage name
]
