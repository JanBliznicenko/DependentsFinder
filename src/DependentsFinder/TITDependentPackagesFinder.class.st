Class {
	#name : 'TITDependentPackagesFinder',
	#superclass : 'Object',
	#instVars : [
		'baselinesByPackages',
		'packagesWithDependencies',
		'dependencyCheckerDependencies',
		'usesDependencyChecker',
		'usesPackageNames'
	],
	#classInstVars : [
		'debugMode'
	],
	#category : 'DependentsFinder-Finder',
	#package : 'DependentsFinder',
	#tag : 'Finder'
}

{ #category : 'examples' }
TITDependentPackagesFinder class >> allByPackages [

	| packages |
	packages := self packageOrganizer packages asSortedCollection.

	^ [ :job |
		  | finder |
		  finder := self new
			            includeInitialPackages;
			            maxAmountOfPackages: (self maxAmountOfPackagesFor: 1);
			            yourself.
		  (packages withIndexCollect: [ :each :index |
				   job title: 'Finding dependent on ' , each name.
				   job value: index - 1.
				   each -> (finder
					    package: each;
					    collect;
					    packages) ]) asOrderedDictionary ] asJob
		  title: 'Finding dependent packages...';
		  max: packages size;
		  run
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> byBaselines [

	^ self byBaselinesLimitedTo: self packageOrganizer packages size
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> byBaselines: baselines [

	^ self
		  byBaselines: baselines
		  limitedTo: self packageOrganizer packages size
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> byBaselines: baselines limitedTo: aMaxAmount [

	^ [ :job |
		  | finder |
		  job value: baselines size negated.
		  finder := self gather.
		  self debugMode ifTrue: [ finder inspect ].
		  (baselines withIndexCollect: [ :each :index |
					   job title: 'Finding dependent on ' , each name.
					   job value: index - 1.
					   each -> (finder query
							    maxAmount: aMaxAmount;
							    packagesToProcess: each version loadedSystemPackages;
							    get) ]) asOrderedDictionary ] asJob
		  title: 'Gathering dependent packages...';
		  min: baselines size negated;
		  max: baselines size;
		  run
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> byBaselinesLimitedTo: aMaxAmount [

	| baselines |
	baselines := (BaselineOf allSubclasses reject: [ :any |
		              any version loadedSystemPackages isEmpty ])
		             asSortedCollection: [ :a :b | a name < b name ].

	^ [ :job |
		  | finder |
		  job value: baselines size negated.
		  finder := self gather.
		  self debugMode ifTrue: [ finder inspect ].
		  (baselines withIndexCollect: [ :each :index |
					   job title: 'Finding dependent on ' , each name.
					   job value: index - 1.
					   each -> (finder query
							    maxAmount: aMaxAmount;
							    packagesToProcess: each version loadedSystemPackages;
							    get) ]) asOrderedDictionary ] asJob
		  title: 'Gathering dependent packages...';
		  min: baselines size negated;
		  max: baselines size;
		  run
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> byPackages [

	^ self byPackagesLimitedTo: self packageOrganizer packages size
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> byPackagesLimitedTo: aMaxAmount [

	| packages |
	packages := self packageOrganizer packages asSortedCollection: [ :a :b |
		            a name < b name ].

	^ [ :job |
		  | finder |
		  job value: packages size negated.
		  finder := self gather.
		  self debugMode ifTrue: [ finder inspect ].
		  (packages withIndexCollect: [ :each :index |
					   job title: 'Finding dependent on ' , each name.
					   job value: index - 1.
					   each -> (finder query
							    maxAmount: aMaxAmount;
							    packagesToProcess: (Set with: each);
							    get) ]) asOrderedDictionary ] asJob
		  title: 'Gathering dependent packages...';
		  min: packages size negated;
		  max: packages size;
		  run
]

{ #category : 'accessing' }
TITDependentPackagesFinder class >> debugMode [

	^ debugMode ifNil: [ false ]
]

{ #category : 'accessing' }
TITDependentPackagesFinder class >> debugMode: aBoolean [

	debugMode := aBoolean
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleByBaselines [

	^ self byBaselines inspect
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> exampleByPackages [

	^ self byPackages inspect
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forBaseline: aBaselineClass [

	^ self forPackages: aBaselineClass version loadedSystemPackages
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forBaseline: aBaselineClass limitedTo: aMaxAmount [

	^ self
		  forPackages: aBaselineClass version loadedSystemPackages
		  limitedTo: aMaxAmount
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forPackage: aPackage [

	^ self forPackages: { aPackage }
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forPackageNamed: aPackageName [

	^ self forPackage: (self packageOrganizer packageNamed: aPackageName)
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forPackages: aSetOfPackages [

	| finder |
	finder := self gather.
	self debugMode ifTrue: [ finder inspect ].
	^ finder query
		  excludePackagesToProcess;
		  packagesToProcess: aSetOfPackages;
		  get
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> forPackages: aSetOfPackages limitedTo: aMaxAmount [

	| finder |
	finder := self gather.
	self debugMode ifTrue: [ finder inspect ].
	^ finder query
		  excludePackagesToProcess;
		  maxAmount: aMaxAmount;
		  packagesToProcess: aSetOfPackages;
		  get
]

{ #category : 'examples' }
TITDependentPackagesFinder class >> gather [

	^ self new
		  gather;
		  yourself
]

{ #category : 'adding' }
TITDependentPackagesFinder >> addDependency: aPackageDependency to: aTargetPackage [

	(self packageWithDependenciesFor: aTargetPackage) add:
		aPackageDependency
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> addDependentsOf: packagesToProcess into: accumulatorOfPackages excluding: excludedPackages limitedTo: aMaxAmount [

	| packagesNotToAdd accumulatorOfPackagesBefore |
	packagesNotToAdd := accumulatorOfPackages asSet , packagesToProcess
	                    , excludedPackages.
	accumulatorOfPackagesBefore := accumulatorOfPackages copy.
	packagesToProcess do: [ :eachOriginalPackage |
			(packagesWithDependencies at: eachOriginalPackage)
				dependentPackages do: [ :eachDependentPackage |
					accumulatorOfPackages size = aMaxAmount ifTrue: [ ^ self ].
					(packagesNotToAdd includes: eachDependentPackage) ifFalse: [
						accumulatorOfPackages add: eachDependentPackage ] ] ].
	accumulatorOfPackages size > accumulatorOfPackagesBefore size
		ifFalse: [ ^ self ].
	self
		addDependentsOf: accumulatorOfPackages \ accumulatorOfPackagesBefore
		into: accumulatorOfPackages
		excluding: excludedPackages
		limitedTo: aMaxAmount
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> baseline: aBaselineClass [

	self packages: aBaselineClass version loadedSystemPackages
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> baselinesByPackages [

	| newBaselinesByPackages |
	baselinesByPackages ifNotNil: [ ^ baselinesByPackages ].
	newBaselinesByPackages := Dictionary new.

	BaselineOf allSubclasses do: [ :eachBaseline |
			self packagesInBaseline: eachBaseline do: [ :eachPackage |
					(newBaselinesByPackages at: eachPackage ifAbsentPut: Set new)
						add: eachBaseline ] ].

	^ baselinesByPackages := newBaselinesByPackages
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> dependencyCheckerDependencies [

	dependencyCheckerDependencies ifNil: [
			dependencyCheckerDependencies := Dictionary new.
			self packageOrganizer packages do: [ :eachSourcePackage |
					(StDependencyChecker new
						 shouldComputeMessageSendDependencies: false;
						 daPackageFor: eachSourcePackage name) allDependencies do: [
							:eachDependency |
							eachDependency targetPackages do: [ :eachTargetPackage |
									(dependencyCheckerDependencies
										 at: eachTargetPackage
										 ifAbsentPut: OrderedCollection new) add: eachDependency ] ] ] ].
	^ dependencyCheckerDependencies
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> dependentsInclusiveOf: packagesToProcess excluding: excludedPackages limitedTo: aMaxAmount [

	| packagesToProcessSet accumulatorOfPackages |
	packagesToProcessSet := packagesToProcess asSet.
	accumulatorOfPackages := packagesToProcessSet \ excludedPackages.
	accumulatorOfPackages size >= aMaxAmount ifFalse: [
			self
				addDependentsOf: packagesToProcessSet
				into: accumulatorOfPackages
				excluding: excludedPackages
				limitedTo: aMaxAmount ].
	^ accumulatorOfPackages
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> dependentsOf: packagesToProcess excluding: excludedPackages limitedTo: aMaxAmount [

	| packagesToProcessSet |
	packagesToProcessSet := packagesToProcess asSet.
	^ self
		  dependentsInclusiveOf: packagesToProcessSet
		  excluding: packagesToProcessSet , excludedPackages
		  limitedTo: aMaxAmount
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> doNotUseDependencyChecker [

	usesDependencyChecker := false
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> doNotUsePackageNames [

	usesPackageNames := false
]

{ #category : 'processing' }
TITDependentPackagesFinder >> gather [

	self gatherForPackages: self packages
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> gatherDependentsViaPackageNameOn: aTargetPackage [

	| projectNames |
	self usesPackageNames ifFalse: [ ^ self ].
	projectNames := { (aTargetPackage name copyUpTo: $-) capitalized }
		                asSet , (IceRepository registry
		                 select: [ :repo |
				                 repo name ~= 'pharo' and: [
					                 repo includesPackageNamed: aTargetPackage name ] ]
		                 thenCollect: [ :each | each name copyUpTo: $- ])
	                ,
		                ((self baselinesByPackages
			                  at: aTargetPackage
			                  ifAbsent: [ Set empty ]) collect: [ :each |
			                 each name allButFirst: 10 ]).
	projectNames removeAllFoundIn:
		#( 'System' 'Tool' 'General' 'Native' 'Pharo' 'Tools' ).
	self packageOrganizer packages
		select: [ :eachPackage |
				projectNames anySatisfy: [ :anyNamePart |
						eachPackage ~= aTargetPackage and: [
							eachPackage name includesSubstring: anyNamePart ] ] ]
		thenDo: [ :eachSourcePackage |
				self
					addDependency: (TITPackageDependency
							 forPackageWithDependencies:
							 (self packageWithDependenciesFor: eachSourcePackage)
							 detail: (TITPackageNameDependency
									  sourcePackage: eachSourcePackage
									  targetPackage: aTargetPackage))
					to: aTargetPackage ]
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> gatherDependentsViaStDepedencyCheckerOn: aTargetPackage [

	self usesDependencyChecker ifFalse: [ ^ self ].
	(self dependencyCheckerDependencies
		 at: aTargetPackage
		 ifAbsent: [ ^ self ]) do: [ :eachStDependency |
			self
				addDependency: (TITPackageDependency
						 forPackageWithDependencies: (self packageWithDependenciesFor:
								  eachStDependency source systemPackage)
						 detail: eachStDependency)
				to: aTargetPackage ]
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> gatherDirectForPackages: packages [

	packages do: [ :eachPackage |
			self
				gatherDependentsViaPackageNameOn: eachPackage;
				gatherDependentsViaStDepedencyCheckerOn: eachPackage ]
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> gatherForPackages: packages [

	| packagesBefore packagesAfter newPackages |
	packagesBefore := self packages.
	self gatherDirectForPackages: packages.
	packagesAfter := self packages.
	newPackages := packagesAfter \ packagesBefore.
	newPackages ifEmpty: [ ^ self ].
	self gatherForPackages: newPackages
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> mergePackageDependency: aPackageDependency [

	| newPackageWithDependencies |
	newPackageWithDependencies := aPackageDependency
		                              packageWithDependencies.

	packagesWithDependencies
		at: newPackageWithDependencies package
		ifPresent: [ :foundPackageWithDependencies |
				foundPackageWithDependencies add: newPackageWithDependencies.
				aPackageDependency packageWithDependencies:
					foundPackageWithDependencies ]
		ifAbsentPut: [ newPackageWithDependencies ]
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> package: aPackage [

	self packages: { aPackage }
]

{ #category : 'adding' }
TITDependentPackagesFinder >> packageWithDependenciesFor: aPackage [

	^ packagesWithDependencies
		  at: aPackage
		  ifAbsentPut: [ TITPackageWithDependencies withPackage: aPackage ]
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> packages [

	packagesWithDependencies ifNil: [
		self packages: self packageOrganizer packages ].
	^ packagesWithDependencies keys asSet
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> packages: aCollectionOfPackages [

	packagesWithDependencies := aCollectionOfPackages
		                            collect: [ :each |
		                            each
		                            ->
		                            (TITPackageWithDependencies
			                             withPackage: each) ]
		                            as: Dictionary
]

{ #category : 'private - processing' }
TITDependentPackagesFinder >> packagesInBaseline: aBaseline do: aBlock [

	aBaseline version loadedSystemPackages do: aBlock
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> packagesSorted [

	^ packagesWithDependencies keys asSortedCollection: [ :a :b |
		  a name < b name ]
]

{ #category : 'processing' }
TITDependentPackagesFinder >> query [

	^ TITDependentPackagesFinderQueryBuilder for: self
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> usePackageNames [

	usesPackageNames := true
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> usesDependencyChecker [

	^ usesDependencyChecker ifNil: [ true ]
]

{ #category : 'accessing' }
TITDependentPackagesFinder >> usesPackageNames [

	^ usesPackageNames ifNil: [ false ]
]
