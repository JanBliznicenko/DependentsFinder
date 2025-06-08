Class {
	#name : 'TITPackageNameDependency',
	#superclass : 'Object',
	#instVars : [
		'targetPackage',
		'sourcePackage'
	],
	#category : 'DependentsFinder-Structure',
	#package : 'DependentsFinder',
	#tag : 'Structure'
}

{ #category : 'instance creation' }
TITPackageNameDependency class >> forPackage: aPackage [

	^ self new
		  package: aPackage;
		  yourself
]

{ #category : 'as yet unclassified' }
TITPackageNameDependency class >> sourcePackage: aSourcePackage targetPackage: aTargetPackage [

	^ self new
		  sourcePackage: aSourcePackage;
		  targetPackage: aTargetPackage;
		  yourself
]

{ #category : 'constants' }
TITPackageNameDependency >> kindName [

	^ #AnyPartOfName
]

{ #category : 'accessing' }
TITPackageNameDependency >> sourcePackage: aPackage [

	sourcePackage := aPackage
]

{ #category : 'accessing' }
TITPackageNameDependency >> sourcePackages [

	^ { sourcePackage }
]

{ #category : 'accessing' }
TITPackageNameDependency >> targetPackage: aPackage [

	targetPackage := aPackage
]

{ #category : 'accessing' }
TITPackageNameDependency >> targetPackages [

	^ { targetPackage }
]
