Class {
	#name : 'TITPackageDependency',
	#superclass : 'Object',
	#instVars : [
		'kindNames',
		'details',
		'packageWithDependencies'
	],
	#category : 'DependentsFinder-Structure',
	#package : 'DependentsFinder',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITPackageDependency class >> forPackageWithDependencies: aPackageWithDependencies detail: aDependency [

	^ self new
		  packageWithDependencies: aPackageWithDependencies;
		  add: aDependency;
		  yourself
]

{ #category : 'adding' }
TITPackageDependency >> add: aDependencyDetail [

	details add: aDependencyDetail.
	kindNames add: aDependencyDetail kindName
]

{ #category : 'adding' }
TITPackageDependency >> addAll: dependencyDetails [

	dependencyDetails do: [ :each | self add: each ]
]

{ #category : 'accessing' }
TITPackageDependency >> details [

	^ details
]

{ #category : 'initialization' }
TITPackageDependency >> initialize [

	super initialize.
	details := SortedCollection sortBlock: [ :a :b |
		           a kindName < b kindName ].
	kindNames := Set new
]

{ #category : 'accessing' }
TITPackageDependency >> package [

	^ packageWithDependencies package
]

{ #category : 'accessing' }
TITPackageDependency >> packageName [

	^ packageWithDependencies packageName
]

{ #category : 'accessing' }
TITPackageDependency >> packageWithDependencies [

	^ packageWithDependencies
]

{ #category : 'accessing' }
TITPackageDependency >> packageWithDependencies: aPackageWithDependencies [

	packageWithDependencies := aPackageWithDependencies
]

{ #category : 'printing' }
TITPackageDependency >> printOn: aStream [

	super printOn: aStream.
	aStream << ' ['
	<< self packageWithDependencies dependencies size asString << ']'
]
