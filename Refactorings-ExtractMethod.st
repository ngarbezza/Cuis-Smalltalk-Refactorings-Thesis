!classDefinition: #ExtractMethodTest category: #'Refactorings-ExtractMethod'!
RefactoringTest subclass: #ExtractMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 4/18/2019 15:00:57'!
test01NewSelectorShouldNotBeEmpty

	| newSelector |
	newSelector _ ''.
	self
		creationWithSelectorNamed: newSelector
		failsWith: NewSelectorPrecondition newSelectorCanNotBeEmptyErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 4/18/2019 15:00:07'!
test02NewSelectorShouldNotContainSeparators

	| newSelector |
	newSelector _ 'my selector'.
	self
		creationWithSelectorNamed: newSelector
		failsWith: NewSelectorPrecondition newSelectorCanNotContainSeparatorsErrorMessage! !


!ExtractMethodTest methodsFor: 'refactor creation' stamp: 'RNG 4/18/2019 16:07:36'!
creationWithSelectorNamed: aSelectorName failsWith: aRefactoringErrorMessage 

	self
		should: [ ExtractMethod toSelector: aSelectorName on: self class ]
		raise: Error - MessageNotUnderstood
		withMessageText: aRefactoringErrorMessage! !


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


!classDefinition: #ExtractMethod category: #'Refactorings-ExtractMethod'!
Object subclass: #ExtractMethod
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExtractMethod class' category: #'Refactorings-ExtractMethod'!
ExtractMethod class
	instanceVariableNames: ''!

!ExtractMethod class methodsFor: 'instance creation' stamp: 'RNG 4/18/2019 16:08:42'!
toSelector: newSelector on: aClass 

	self ensure: newSelector canBeDefinedIn: aClass! !


!ExtractMethod class methodsFor: 'validations' stamp: 'RNG 4/18/2019 16:08:48'!
ensure: aSelector canBeDefinedIn: aClass 

	NewSelectorPrecondition valueFor: aSelector on: aClass! !
