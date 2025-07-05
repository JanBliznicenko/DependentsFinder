Class {
	#name : 'TITDependentPackagesFinderQueryBuilder',
	#superclass : 'Object',
	#instVars : [
		'packagesToProcess',
		'excludedPackages',
		'finder',
		'maxAmount',
		'excludesPackagesToProcess'
	],
	#category : 'DependentsFinder-Finder',
	#package : 'DependentsFinder',
	#tag : 'Finder'
}

{ #category : 'instance creation' }
TITDependentPackagesFinderQueryBuilder class >> for: aFinder [

	^ self new
		  finder: aFinder;
		  yourself
]

{ #category : 'accessing' }
TITDependentPackagesFinderQueryBuilder >> excludePackagesToProcess [

	excludesPackagesToProcess := true
]

{ #category : 'accessing' }
TITDependentPackagesFinderQueryBuilder >> excludedPackages: aCollectionOfPackages [

	excludedPackages := aCollectionOfPackages asSet
]

{ #category : 'accessing' }
TITDependentPackagesFinderQueryBuilder >> finder: aDependencyFinder [

	finder := aDependencyFinder
]

{ #category : 'processing' }
TITDependentPackagesFinderQueryBuilder >> get [

	| accumulatorOfPackages |
	accumulatorOfPackages := Set new.
	excludesPackagesToProcess ifFalse: [
			accumulatorOfPackages := packagesToProcess \ excludedPackages.
			accumulatorOfPackages size >= self maxAmount ifTrue: [
				^ accumulatorOfPackages ] ].

	finder
		addDependentsOf: packagesToProcess
		into: accumulatorOfPackages
		excluding: excludedPackages
		limitedTo: self maxAmount.
	^ accumulatorOfPackages
]

{ #category : 'accessing' }
TITDependentPackagesFinderQueryBuilder >> includePackagesToProcess [

	excludesPackagesToProcess := false
]

{ #category : 'initialization' }
TITDependentPackagesFinderQueryBuilder >> initialize [

	super initialize.
	excludesPackagesToProcess := true.
	excludedPackages := Set empty
]

{ #category : 'accessing' }
TITDependentPackagesFinderQueryBuilder >> maxAmount [

	^ maxAmount ifNil: [ packagesToProcess size * 2 + 40 ]
]

{ #category : 'accessing' }
TITDependentPackagesFinderQueryBuilder >> maxAmount: anInteger [

	maxAmount := anInteger
]

{ #category : 'accessing' }
TITDependentPackagesFinderQueryBuilder >> packagesToProcess: aCollectionOfPackages [

	packagesToProcess := aCollectionOfPackages asSet
]
