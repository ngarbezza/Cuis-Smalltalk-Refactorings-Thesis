!classDefinition: #ExtractMethodTest category: #'Refactorings-ExtractMethod'!
RefactoringTest subclass: #ExtractMethodTest
	instanceVariableNames: 'classToRefactor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 4/20/2019 22:01:56'!
test01NewSelectorShouldNotBeEmpty

	self
		creationWithSelectorNamed: #''
		failsWith: NewSelectorPrecondition newSelectorCanNotBeEmptyErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 4/20/2019 22:01:48'!
test02NewSelectorShouldNotContainSeparators

	self
		creationWithSelectorNamed: #'my selector'
		failsWith: NewSelectorPrecondition newSelectorCanNotContainSeparatorsErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 4/20/2019 21:35:50'!
test03NewSelectorShouldNotBeAlreadyDefinedInTheClass

	self
		creationWithSelectorNamed: #m1
		failsWith: NewSelectorPrecondition newSelectorAlreadyDefinedOnTheClassErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 4/20/2019 22:01:13'!
test04IntervalToExtractIsNotBeforeMethodSourceCodeBoundaries

	| selectorToExtractCodeFrom sourceCodeToExtract sourceCode |
	sourceCodeToExtract _ '4'.
	selectorToExtractCodeFrom _ #m1.
	sourceCode _ selectorToExtractCodeFrom asString , ' ^ ' , sourceCodeToExtract.
	classToRefactor compile: sourceCode.

	self
		creationWithSelectorNamed: #m2
		onInterval: (-1 to: 2)
		ofMethod: classToRefactor >> selectorToExtractCodeFrom
		failsWith: ExtractMethod outOfBoundsSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 4/20/2019 22:03:29'!
test05IntervalToExtractIsNotAfterMethodSourceCodeBoundaries

	| selectorToExtractCodeFrom sourceCodeToExtract sourceCode |
	sourceCodeToExtract _ '4'.
	selectorToExtractCodeFrom _ #m1.
	sourceCode _ selectorToExtractCodeFrom asString , ' ^ ' , sourceCodeToExtract.
	classToRefactor compile: sourceCode.

	self
		creationWithSelectorNamed: #m2
		onInterval: (1 to: 12)
		ofMethod: classToRefactor >> selectorToExtractCodeFrom
		failsWith: ExtractMethod outOfBoundsSelectionErrorMessage! !


!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 4/20/2019 22:01:13'!
creationWithSelectorNamed: aSelectorName failsWith: aRefactoringErrorMessage

	| selectorToExtractCodeFrom sourceCodeToExtract intervalToExtract sourceCode |
	sourceCodeToExtract _ '4'.
	selectorToExtractCodeFrom _ #m1.
	sourceCode _ selectorToExtractCodeFrom asString , ' ^ ' , sourceCodeToExtract.
	classToRefactor compile: sourceCode.
	intervalToExtract _ sourceCode intervalOfSubCollection: sourceCodeToExtract.

	self
		creationWithSelectorNamed: aSelectorName
		onInterval: intervalToExtract
		ofMethod: classToRefactor >> selectorToExtractCodeFrom
		failsWith: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 4/20/2019 21:29:59'!
creationWithSelectorNamed: aSelectorName onInterval: anIntervalToExtract ofMethod: methodToExtractCodeFrom failsWith: aRefactoringErrorMessage

	self
		should: [
			ExtractMethod
				fromInterval: anIntervalToExtract
				of: methodToExtractCodeFrom
				to: aSelectorName ]
		raise: Error - MessageNotUnderstood
		withMessageText: aRefactoringErrorMessage! !


!ExtractMethodTest methodsFor: 'class factory' stamp: 'RNG 4/20/2019 21:31:05'!
classToRefactorName

	^ #ClassToExtractMethod! !


!ExtractMethodTest methodsFor: 'set up' stamp: 'RNG 4/20/2019 22:01:13'!
setUp

	super setUp.
	classToRefactor _ self createClassNamed: self classToRefactorName.! !


!classDefinition: #NewSelectorPreconditionTest category: #'Refactorings-ExtractMethod'!
TestCase subclass: #NewSelectorPreconditionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

!NewSelectorPreconditionTest methodsFor: 'assertions' stamp: 'RNG 4/18/2019 15:57:28'!
assertPreconditionForSelector: selectorToValidate failsWith: preconditionFailedErrorMessage

	self
		assertPreconditionForSelector: selectorToValidate
		ofClass: self class
		failsWith: preconditionFailedErrorMessage! !

!NewSelectorPreconditionTest methodsFor: 'assertions' stamp: 'RNG 4/18/2019 15:57:06'!
assertPreconditionForSelector: selectorToValidate ofClass: aClass failsWith: preconditionFailedErrorMessage

	self
		should: [ NewSelectorPrecondition valueFor: selectorToValidate on: aClass ]
		raise: Error - MessageNotUnderstood
		withMessageText: preconditionFailedErrorMessage! !


!NewSelectorPreconditionTest methodsFor: 'tests' stamp: 'RNG 4/18/2019 14:37:21'!
test01NewSelectorShouldNotBeEmpty

	self
		assertPreconditionForSelector: ''
		failsWith: NewSelectorPrecondition newSelectorCanNotBeEmptyErrorMessage! !

!NewSelectorPreconditionTest methodsFor: 'tests' stamp: 'RNG 4/18/2019 14:55:32'!
test02NewSelectorShouldNotContainSeparators

	self
		assertPreconditionForSelector: 'my selector'
		failsWith: NewSelectorPrecondition newSelectorCanNotContainSeparatorsErrorMessage! !

!NewSelectorPreconditionTest methodsFor: 'tests' stamp: 'RNG 4/18/2019 15:33:56'!
test03NewSelectorShouldNotStartWithANumber

	self
		assertPreconditionForSelector: '2selector'
		failsWith: NewSelectorPrecondition newSelectorCanNotStartWithANumberErrorMessage! !

!NewSelectorPreconditionTest methodsFor: 'tests' stamp: 'RNG 4/18/2019 15:41:13'!
test04NewSelectorShouldNotStartWithAnUppercaseLetter

	self
		assertPreconditionForSelector: 'TheSelector'
		failsWith: NewSelectorPrecondition newSelectorCanNotStartWithAnUppercaseLetterErrorMessage! !

!NewSelectorPreconditionTest methodsFor: 'tests' stamp: 'RNG 4/18/2019 15:58:06'!
test05NewSelectorShouldNotExistOnTheGivenClass

	self
		assertPreconditionForSelector: #test05NewSelectorShouldNotExistOnTheGivenClass
		ofClass: self class
		failsWith: NewSelectorPrecondition newSelectorAlreadyDefinedOnTheClassErrorMessage! !


!classDefinition: #ExtractMethod category: #'Refactorings-ExtractMethod'!
Refactoring subclass: #ExtractMethod
	instanceVariableNames: 'intervalToExtract sourceMethod newSelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

!ExtractMethod methodsFor: 'initialization' stamp: 'RNG 4/20/2019 21:33:57'!
initializeFrom: anIntervalToExtract of: aMethodToExtractCodeFrom to: aNewSelector

	intervalToExtract _ anIntervalToExtract.
	sourceMethod _ aMethodToExtractCodeFrom.
	newSelector _ aNewSelector
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExtractMethod class' category: #'Refactorings-ExtractMethod'!
ExtractMethod class
	instanceVariableNames: ''!

!ExtractMethod class methodsFor: 'instance creation' stamp: 'RNG 4/20/2019 21:39:04'!
fromInterval: anIntervalToExtract of: aMethodToExtractCodeFrom to: aNewSelector

	self
		ensure: aNewSelector canBeDefinedIn: aMethodToExtractCodeFrom methodClass;
		ensure: anIntervalToExtract isValidIntervalOn: aMethodToExtractCodeFrom.

	^ self new
		initializeFrom: anIntervalToExtract
		of: aMethodToExtractCodeFrom
		to: aNewSelector! !


!ExtractMethod class methodsFor: 'validations' stamp: 'RNG 4/18/2019 16:08:48'!
ensure: aSelector canBeDefinedIn: aClass 

	NewSelectorPrecondition valueFor: aSelector on: aClass! !

!ExtractMethod class methodsFor: 'validations' stamp: 'RNG 4/20/2019 21:56:33'!
ensure: anIntervalToExtract isValidIntervalOn: aMethodToExtractCodeFrom 

	(self is: anIntervalToExtract withinBoundsOf: aMethodToExtractCodeFrom sourceCode) ifFalse: [ self signalOutOfBoundsIntervalError ]! !


!ExtractMethod class methodsFor: 'error messages' stamp: 'RNG 4/20/2019 21:53:45'!
outOfBoundsSelectionErrorMessage

	^ 'The source code selection interval is out of bounds'! !


!ExtractMethod class methodsFor: 'exceptions' stamp: 'RNG 4/20/2019 21:53:24'!
signalOutOfBoundsIntervalError

	self refactoringError: self outOfBoundsSelectionErrorMessage! !


!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 4/20/2019 21:56:55'!
is: anIntervalToExtract withinBoundsOf: aSourceCode

	^ anIntervalToExtract first >= 1 and: [ anIntervalToExtract last <= aSourceCode size ]! !


!classDefinition: #NewSelectorPrecondition category: #'Refactorings-ExtractMethod'!
RefactoringPrecondition subclass: #NewSelectorPrecondition
	instanceVariableNames: 'selectorToValidate classToDefineSelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

!NewSelectorPrecondition methodsFor: 'evaluating' stamp: 'RNG 4/18/2019 16:02:13'!
value

	self
		assertNewSelectorIsNotEmpty;
		assertNewSelectorDoesNotContainSeparators;
		assertNewSelectorDoesNotStartWithANumber;
		assertNewSelectorDoesNotStartWithAnUppercaseLetter;
		assertNewSelectorIsNotAlreadyDefinedInTheClass! !


!NewSelectorPrecondition methodsFor: 'initialization' stamp: 'RNG 4/18/2019 16:04:44'!
initializeFor: aSelectorToValidate on: aClassToDefineSelector

	selectorToValidate _ aSelectorToValidate.
	classToDefineSelector _ aClassToDefineSelector! !


!NewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 4/18/2019 15:11:55'!
signalNewSelectorCanNotBeEmptyError

	self refactoringError: self class newSelectorCanNotBeEmptyErrorMessage! !

!NewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 4/18/2019 15:13:59'!
signalNewSelectorCanNotContainSeparatorsError

	self error: self class newSelectorCanNotContainSeparatorsErrorMessage! !

!NewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 4/18/2019 15:36:23'!
signalNewSelectorCanNotStartWithANumberError

	self error: self class newSelectorCanNotStartWithANumberErrorMessage! !

!NewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 4/18/2019 15:41:13'!
signalNewSelectorCanNotStartWithAnUppercaseLetterError

	self refactoringError: self class newSelectorCanNotStartWithAnUppercaseLetterErrorMessage! !

!NewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 4/18/2019 16:04:10'!
signalNewSelectorIsAlreadyDefinedInTheClassError

	^ self refactoringError: self class newSelectorAlreadyDefinedOnTheClassErrorMessage! !


!NewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 4/18/2019 15:13:52'!
assertNewSelectorDoesNotContainSeparators

	(selectorToValidate anySatisfy: [ :character | character isSeparator ])
		ifTrue: [ self signalNewSelectorCanNotContainSeparatorsError ]! !

!NewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 4/18/2019 15:36:32'!
assertNewSelectorDoesNotStartWithANumber

	selectorToValidate first isDigit ifTrue: [ self signalNewSelectorCanNotStartWithANumberError ].! !

!NewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 4/18/2019 15:40:19'!
assertNewSelectorDoesNotStartWithAnUppercaseLetter
	
	selectorToValidate first isUppercase ifTrue: [ self signalNewSelectorCanNotStartWithAnUppercaseLetterError ]! !

!NewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 4/18/2019 16:06:39'!
assertNewSelectorIsNotAlreadyDefinedInTheClass

	(classToDefineSelector includesSelector: selectorToValidate)
	ifTrue: [ self signalNewSelectorIsAlreadyDefinedInTheClassError ].! !

!NewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 4/18/2019 15:11:46'!
assertNewSelectorIsNotEmpty

	selectorToValidate ifEmpty: [ self signalNewSelectorCanNotBeEmptyError ].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NewSelectorPrecondition class' category: #'Refactorings-ExtractMethod'!
NewSelectorPrecondition class
	instanceVariableNames: ''!

!NewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:58:58'!
newSelectorAlreadyDefinedOnTheClassErrorMessage

	^ 'New selector is already defined on this class'! !

!NewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 14:40:21'!
newSelectorCanNotBeEmptyErrorMessage

	^ 'New selector can not be empty'! !

!NewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:05:41'!
newSelectorCanNotContainSeparatorsErrorMessage

	^ 'New selector can not contain separators'! !

!NewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:34:30'!
newSelectorCanNotStartWithANumberErrorMessage

	^ 'New selector can not start with a number'! !

!NewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:41:13'!
newSelectorCanNotStartWithAnUppercaseLetterErrorMessage

	^ 'New selector can not start with an uppercase letter'! !


!NewSelectorPrecondition class methodsFor: 'instance creation' stamp: 'RNG 4/18/2019 16:01:43'!
for: aSelectorToValidate on: aClass 

	^ self new initializeFor: aSelectorToValidate on: aClass! !


!NewSelectorPrecondition class methodsFor: 'evaluating' stamp: 'RNG 4/18/2019 15:59:44'!
valueFor: aSelectorToValidate on: aClass

	^ (self for: aSelectorToValidate on: aClass) value! !
