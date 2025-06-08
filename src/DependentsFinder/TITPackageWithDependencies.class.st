Class {
	#name : 'TITPackageWithDependencies',
	#superclass : 'Object',
	#instVars : [
		'package',
		'dependencies'
	],
	#category : 'DependentsFinder-Structure',
	#package : 'DependentsFinder',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITPackageWithDependencies class >> withPackage: aPackage [

	^ self new
		  package: aPackage;
		  yourself
]

{ #category : 'instance creation' }
TITPackageWithDependencies class >> withPackage: aPackage dependencies: aCollection [

	^ (self withPackage: aPackage)
		  addAll: aCollection;
		  yourself
]

{ #category : 'instance creation' }
TITPackageWithDependencies class >> withPackage: aPackage dependency: aDependency [

	^ (self withPackage: aPackage)
		  add: aDependency;
		  yourself
]

{ #category : 'accessing' }
TITPackageWithDependencies >> add: aDependency [

	dependencies
		at: aDependency package
		ifPresent: [ :existingDependency |
			existingDependency addAll: aDependency details ]
		ifAbsentPut: [ aDependency ]
]

{ #category : 'accessing' }
TITPackageWithDependencies >> addAll: aCollection [

	aCollection do: [ :each | self add: each ]
]

{ #category : 'accessing' }
TITPackageWithDependencies >> dependencies [

	^ dependencies
]

{ #category : 'accessing' }
TITPackageWithDependencies >> dependentPackages [

	^ dependencies keys
]

{ #category : 'initialization' }
TITPackageWithDependencies >> initialize [

	super initialize.
	dependencies := Dictionary new
]

{ #category : 'accessing' }
TITPackageWithDependencies >> package [

	^ package
]

{ #category : 'accessing' }
TITPackageWithDependencies >> package: aPackage [

	package := aPackage
]

{ #category : 'accessing' }
TITPackageWithDependencies >> packageName [

	^ package name
]

{ #category : 'printing' }
TITPackageWithDependencies >> printOn: aStream [

	super printOn: aStream.
	self package ifNil: [ ^ self ].
	aStream << ' (' << self packageName << ') ['
	<< self dependencies size asString << ']'
]
