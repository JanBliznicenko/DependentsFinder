Extension { #name : 'StPackageDependency' }

{ #category : '*DependentsFinder' }
StPackageDependency >> allDependencies [

	^ Array with: self
]

{ #category : '*DependentsFinder' }
StPackageDependency >> kindName [

	^ ((self className allButFirst: 2) allButLast: 10) asSymbol
]

{ #category : '*DependentsFinder' }
StPackageDependency >> sourcePackages [

	source systemPackage ifNotNil: [ :package | ^ Set with: package ].
	^ Set empty
]

{ #category : '*DependentsFinder' }
StPackageDependency >> targetPackages [

	target systemPackage ifNotNil: [ :package | ^ Set with: package ].
	^ Set empty
]
