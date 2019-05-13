'From Cuis 5.0 of 7 November 2016 [latest update: #3741] on 13 May 2019 at 2:53:19 am'!
'Description Tests for the Extract Method refactoring.'!
!provides: 'Tests-Refactorings-ExtractMethod' 1 2!
!requires: 'Refactorings-ExtractMethod' 1 0 nil!
!requires: 'BaseImageTests' 1 149 nil!
SystemOrganization addCategory: #'Tests-Refactorings-ExtractMethod'!


!classDefinition: #ExtractMethodTest category: #'Tests-Refactorings-ExtractMethod'!
RefactoringTest subclass: #ExtractMethodTest
	instanceVariableNames: 'classToRefactor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tests-Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodTest class' category: #'Tests-Refactorings-ExtractMethod'!
ExtractMethodTest class
	instanceVariableNames: ''!


!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 4/29/2019 00:30:56'!
assertClassHasDefined: newSelector withBody: newSourceCode

	self
		assert: (classToRefactor >> newSelector) sourceCode
		equals: newSourceCode! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 5/8/2019 23:34:49'!
assertClassHasDefined: newSelector withBody: newSourceCode inCategory: aCategory

	self assertClassHasDefined: newSelector withBody: newSourceCode.
	self assert: aCategory equals: (classToRefactor >> newSelector) category! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 5/12/2019 23:20:10'!
creationOnInterval: anIntervalToExtract failsWith: aRefactoringErrorMessage

	self
		creationWithSelectorNamed: #aValidSelector
		onInterval: anIntervalToExtract
		ofMethod: self methodToExtractCodeFrom
		failsWith: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 5/12/2019 23:20:29'!
creationWithSelectorNamed: aSelectorName failsWith: aRefactoringErrorMessage

	self
		creationWithSelectorNamed: aSelectorName
		onInterval: self intervalToExtractFromMethod
		ofMethod: self methodToExtractCodeFrom
		failsWith: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 5/12/2019 23:20:47'!
creationWithSelectorNamed: aSelectorName onInterval: anIntervalToExtract ofMethod: methodToExtractCodeFrom failsWith: aRefactoringErrorMessage

	self
		should: [
			ExtractMethod
				fromInterval: anIntervalToExtract
				of: methodToExtractCodeFrom
				to: aSelectorName
				categorizedAs: Categorizer default ]
		raise: Error - MessageNotUnderstood
		withMessageText: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'class factory' stamp: 'RNG 4/20/2019 21:31:05'!
classToRefactorName

	^ #ClassToExtractMethod! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:21:30'!
compileMethodToExtractCodeFrom

	classToRefactor compile: self sourceCodeOfMethodToExtractCodeFrom! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:21:30'!
intervalToExtractFromMethod

	^ self sourceCodeOfMethodToExtractCodeFrom intervalOfSubCollection: '4'! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:22:01'!
methodToExtractCodeFrom

	^ classToRefactor >> self selectorOfMethodToExtractCodeFrom! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:25:05'!
selectorOfMethodToExtractCodeFrom

	^ #mExtractMethodExample:! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/13/2019 01:17:25'!
sourceCodeOfMethodToExtractCodeFrom

	^ self selectorOfMethodToExtractCodeFrom, ' anArgument

	<anAnnoyingPragma>
	| localVar |
	<anotherAnnoyingPragma>
	self m2.
	self m3: anArgument.
	localVar := 3.
	^ localVar + 4'! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:32:28'!
updatedSourceCodeAfterExtractingTo: newSelector

	^ self sourceCodeOfMethodToExtractCodeFrom
		copyReplaceFrom: self intervalToExtractFromMethod first
		to: self intervalToExtractFromMethod last - 1
		with: 'self ' , newSelector asString! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 5/12/2019 23:26:00'!
applyExtractMethodTo: newSelector on: aCategory 

	(ExtractMethod
		fromInterval: self intervalToExtractFromMethod
		of: self methodToExtractCodeFrom
		to: newSelector
		categorizedAs: aCategory) apply! !

!ExtractMethodTest methodsFor: 'set up' stamp: 'RNG 5/12/2019 23:21:15'!
setUp

	super setUp.
	classToRefactor _ self createClassNamed: self classToRefactorName.
	self compileMethodToExtractCodeFrom.! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 5/12/2019 23:32:19'!
test09ExtractingALiteralCreatesANewMethodAndChangesExistingCodeToCallThatNewMethod

	| newSelector sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	newSelector _ #newMethod.
	sourceCodeOfNewMethod _ newSelector asString , '

	^ 4'.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtractingTo: newSelector.

	self applyExtractMethodTo: newSelector on: #category.

	self assertClassHasDefined: newSelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/4/2019 22:40:07'!
test01NewSelectorShouldNotBeEmpty

	self
		creationWithSelectorNamed: #''
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorCanNotBeEmptyErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/4/2019 22:40:07'!
test02NewSelectorShouldNotContainSeparators

	self
		creationWithSelectorNamed: #'my selector'
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorCanNotContainSeparatorsErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/12/2019 23:22:01'!
test03NewSelectorShouldNotBeAlreadyDefinedInTheClass

	self
		creationWithSelectorNamed: self selectorOfMethodToExtractCodeFrom
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorAlreadyDefinedOnTheClassErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/5/2019 12:19:39'!
test04NewSelectorShouldNotStartWithANumber

	self
		creationWithSelectorNamed: #'2selector'
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorCanNotStartWithANumberErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/5/2019 12:19:49'!
test05NewSelectorShouldNotStartWithAnUppercaseLetter

	self
		creationWithSelectorNamed: #TheSelector
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorCanNotStartWithAnUppercaseLetterErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/5/2019 12:20:04'!
test06IntervalToExtractIsNotBeforeMethodSourceCodeBoundaries

	self
		creationOnInterval: (-1 to: 2)
		failsWith: ExtractMethod outOfBoundsSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/12/2019 23:29:42'!
test07IntervalToExtractIsNotAfterMethodSourceCodeBoundaries

	self
		creationOnInterval: (1 to: self sourceCodeOfMethodToExtractCodeFrom size + 2)
		failsWith: ExtractMethod outOfBoundsSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/12/2019 23:30:12'!
test08IntervalToExtractShouldNotContainAReturnExpression

	| intervalToExtract |
	intervalToExtract  _ self sourceCodeOfMethodToExtractCodeFrom intervalOfSubCollection: '^ localVar + 4'.
	self
		creationOnInterval: intervalToExtract
		failsWith: ExtractMethod returnInSourceToExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/12/2019 23:42:02'!
test10IntervalToExtractDoesNotContainsPartOfTheOriginalSelector

	| intervalToExtract |
	intervalToExtract  _ self sourceCodeOfMethodToExtractCodeFrom
		intervalOfSubCollection: self selectorOfMethodToExtractCodeFrom asString.
	self
		creationOnInterval: intervalToExtract
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/13/2019 00:03:19'!
test11IntervalToExtractDoesNotContainsPartOfLocalVariablesDefinition

	| intervalToExtract |
	intervalToExtract  _ self sourceCodeOfMethodToExtractCodeFrom
		intervalOfSubCollection: '| localVar |'.
	self
		creationOnInterval: intervalToExtract
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/13/2019 01:17:49'!
test12IntervalToExtractDoesNotContainsPartOfPragmasDefinition

	| intervalToExtract |
	intervalToExtract  _ self sourceCodeOfMethodToExtractCodeFrom
		intervalOfSubCollection: '<anotherAnnoyingPragma>'.
	self
		creationOnInterval: intervalToExtract
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/13/2019 01:39:03'!
test13IntervalToExtractShouldBeAValidSmalltalkExpression

	| intervalToExtract |
	intervalToExtract  _ self sourceCodeOfMethodToExtractCodeFrom
		intervalOfSubCollection: '+ 4'.
	self
		creationOnInterval: intervalToExtract
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/13/2019 02:48:59'!
test14OriginalCodeShouldNotEndUpWIthSyntaxErrors

	| firstOccurrence secondOccurrence intervalToExtract |
	firstOccurrence _ self sourceCodeOfMethodToExtractCodeFrom
		indexOfSubCollection: 'localVar' startingAt: 1.
	secondOccurrence _ self sourceCodeOfMethodToExtractCodeFrom
		indexOfSubCollection: 'localVar' startingAt: firstOccurrence + 1.
	intervalToExtract _ secondOccurrence toSelfPlus: 'localVar' size.
	self
		creationOnInterval: intervalToExtract
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !
