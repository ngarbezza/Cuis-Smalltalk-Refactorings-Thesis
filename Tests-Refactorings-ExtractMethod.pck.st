'From Cuis 5.0 [latest update: #3866] on 7 September 2019 at 7:28:00 pm'!
'Description Tests for the Extract Method refactoring.'!
!provides: 'Tests-Refactorings-ExtractMethod' 1 12!
!requires: 'Refactorings-ExtractMethod' 1 0 nil!
!requires: 'BaseImageTests' 1 149 nil!
SystemOrganization addCategory: #'Tests-Refactorings-ExtractMethod'!


!classDefinition: #ExtractMethodTest category: #'Tests-Refactorings-ExtractMethod'!
RefactoringTest subclass: #ExtractMethodTest
	instanceVariableNames: 'classToRefactor newUnaryMessage newUnarySelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Tests-Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodTest class' category: #'Tests-Refactorings-ExtractMethod'!
ExtractMethodTest class
	instanceVariableNames: ''!


!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 6/23/2019 18:30:13'!
assertClassHasDefined: aSelector withBody: newSourceCode

	self
		assert: (classToRefactor >> aSelector) sourceCode
		equals: newSourceCode! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 6/23/2019 18:30:02'!
assertClassHasDefined: aSelector withBody: newSourceCode inCategory: aCategory

	self assertClassHasDefined: aSelector withBody: newSourceCode.
	self assert: aCategory equals: (classToRefactor >> aSelector) category! !

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

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 6/23/2019 18:21:38'!
creationWithSelectorNamed: aSelectorName onInterval: anIntervalToExtract ofMethod: methodToExtractCodeFrom failsWith: aRefactoringErrorMessage

	self
		should: [
			ExtractMethod
				fromInterval: anIntervalToExtract
				of: methodToExtractCodeFrom
				to: (Message selector: aSelectorName)
				categorizedAs: Categorizer default ]
		raise: Error - MessageNotUnderstood
		withMessageText: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'class factory' stamp: 'RNG 4/20/2019 21:31:05'!
classToRefactorName

	^ #ClassToExtractMethod! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:21:30'!
compileMethodToExtractCodeFrom

	classToRefactor compile: self sourceCodeOfMethodToExtractCodeFrom! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/28/2019 00:30:11'!
intervalToExtractFromMethod

	^ self intervalOfCode: '4'! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:22:01'!
methodToExtractCodeFrom

	^ classToRefactor >> self selectorOfMethodToExtractCodeFrom! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 6/23/2019 19:49:14'!
newMethodDefinitionOf: newMessage including: newSourceCode

	^ newMessage fullName , '

	' , newSourceCode! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 6/23/2019 19:49:31'!
newMethodDefinitionWith: newSourceCode

	^ self newMethodDefinitionOf: newUnaryMessage including: newSourceCode! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:25:05'!
selectorOfMethodToExtractCodeFrom

	^ #mExtractMethodExample:! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 7/6/2019 19:24:17'!
sourceCodeOfMethodToExtractCodeFrom

	^ self selectorOfMethodToExtractCodeFrom, ' anArgument

	<anAnnoyingPragma>
	| localVar |
	<anotherAnnoyingPragma>
	self m1.
	self m2: ''hey true''.
	self m3: anArgument , ''^ 21''.
	localVar := #($x $y $z) size and: [ (9) * 3 ].
	^ localVar + ((4))'! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 6/23/2019 19:47:39'!
updatedSourceCodeAfterExtracting: anInterval 

	^ self updatedSourceCodeAfterExtracting: anInterval to: newUnaryMessage! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 6/23/2019 19:46:56'!
updatedSourceCodeAfterExtracting: anInterval to: newMessage

	^ self sourceCodeOfMethodToExtractCodeFrom
		copyReplaceFrom: anInterval first
		to: anInterval last
		with: 'self ' , newMessage fullName! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 6/23/2019 18:33:05'!
updatedSourceCodeAfterExtractingNewMethod

	^ self updatedSourceCodeAfterExtracting: self intervalToExtractFromMethod ! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 7/7/2019 23:42:34'!
applyExtractMethodOf: anInterval on: aCategory 

	self applyExtractMethodOf: anInterval to: newUnaryMessage on: aCategory! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 7/7/2019 23:42:22'!
applyExtractMethodOf: anInterval to: newMessage on: aCategory

	(ExtractMethod
		fromInterval: anInterval
		of: self methodToExtractCodeFrom
		to: newMessage
		categorizedAs: aCategory) apply! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 6/23/2019 18:34:56'!
applyExtractMethodOn: aCategory

	self applyExtractMethodOf: self intervalToExtractFromMethod on: aCategory! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 5/28/2019 00:32:05'!
intervalOfCode: aPieceOfSourceCode

	| interval |
	interval _ self sourceCodeOfMethodToExtractCodeFrom intervalOfSubCollection: aPieceOfSourceCode.
	^ interval first to: interval last - 1! !

!ExtractMethodTest methodsFor: 'set up' stamp: 'RNG 6/23/2019 19:24:46'!
setUp

	super setUp.
	classToRefactor _ self createClassNamed: self classToRefactorName.
	self compileMethodToExtractCodeFrom.
	newUnaryMessage _ Message selector: #newMethod.
	newUnarySelector _ newUnaryMessage selector! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 6/23/2019 19:24:46'!
test09ExtractingALiteralCreatesANewMethodAndChangesExistingCodeToCallThatNewMethod

	| sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	sourceCodeOfNewMethod _ self newMethodDefinitionWith: '^ 4'.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtractingNewMethod.

	self applyExtractMethodOn: #category.

	self assertClassHasDefined: newUnarySelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 6/23/2019 19:24:46'!
test15ExtractingAListOfStatementsCreatesANewMethodWithoutReturn

	| codeToExtract intervalToExtract sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	codeToExtract _
	'self m1.
	self m2: ''hey true'''.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	sourceCodeOfNewMethod _ self newMethodDefinitionWith: codeToExtract.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: intervalToExtract .

	self applyExtractMethodOf: intervalToExtract on: #category.

	self assertClassHasDefined: newUnarySelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 6/23/2019 19:24:46'!
test17AStringContainingTheReturnCharacterCanBeExtracted
	"this is to make sure the return is found using AST logic, not by text"

	| codeToExtract intervalToExtract sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	codeToExtract _ '''^ 21'''.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	sourceCodeOfNewMethod _ self newMethodDefinitionWith: '^ ' , codeToExtract.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: intervalToExtract .

	self applyExtractMethodOf: intervalToExtract on: #category.

	self assertClassHasDefined: newUnarySelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 6/23/2019 19:24:46'!
test18ExtractingAListOfStatementsIncludingDotsRemovesThemAndContinuesWithMethodExtraction

	| codeToExtract intervalToExtract actualIntervalToExtract sourceCodeOfNewMethod updatedSourceCodeOfOriginalMethod expectedExtractedCode |
	codeToExtract _
	'
	self m1.
	self m2: ''hey true''.'.
	expectedExtractedCode _ "trimmed initial enter and space, and ending dot"
	'self m1.
	self m2: ''hey true'''.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	actualIntervalToExtract _ self intervalOfCode: expectedExtractedCode.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: actualIntervalToExtract .
	sourceCodeOfNewMethod _ self newMethodDefinitionWith: expectedExtractedCode.

	self applyExtractMethodOf: intervalToExtract on: #category.

	self assertClassHasDefined: newUnarySelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: self selectorOfMethodToExtractCodeFrom withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 6/23/2019 19:24:46'!
test19ASelectionContainingAdditionalParenthesesAtTheBeginningAndOrEndCanBeExtracted

	| codeToExtract intervalToExtract expectedIntervalToExtract sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	codeToExtract _ '((4))'.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	expectedIntervalToExtract _ self intervalOfCode: '4'.
	sourceCodeOfNewMethod _ self newMethodDefinitionWith: '^ 4'.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: expectedIntervalToExtract .

	self applyExtractMethodOf: intervalToExtract on: #category.

	self assertClassHasDefined: newUnarySelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 6/23/2019 21:15:08'!
test20ASelectionContainingALocalVariableIsParameterizedOnTheExtractedMessage

	| codeToExtract intervalToExtract sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod newMessage |
	codeToExtract _ 'anArgument , ''^ 21'''.
	newMessage _ Message selector: #extractWithParam: arguments: { 'anArgument' }.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	sourceCodeOfNewMethod _ self newMethodDefinitionOf: newMessage including: '^ ' , codeToExtract.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: intervalToExtract to: newMessage.

	self applyExtractMethodOf: intervalToExtract to: newMessage on: #category.

	self assertClassHasDefined: newMessage selector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 7/6/2019 19:24:29'!
test21ASelectionContainingAdditionalParenthesesOnOneSideCanBeExtractedAndItIsNotTrimmed

	| codeToExtract intervalToExtract sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	codeToExtract _ '(9) * 3'.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	sourceCodeOfNewMethod _ self newMethodDefinitionWith: '^ ', codeToExtract.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: intervalToExtract.

	self applyExtractMethodOf: intervalToExtract on: #category.

	self assertClassHasDefined: newUnarySelector withBody: sourceCodeOfNewMethod inCategory: #category.
	self assertClassHasDefined: originalSelector withBody: updatedSourceCodeOfOriginalMethod! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/7/2019 19:27:09'!
test22ItIsPossibleToExtractTheLastExpressionOfAMethod

	| codeToExtract intervalToExtract sourceCodeOfNewMethod originalSelector updatedSourceCodeOfOriginalMethod |
	codeToExtract _ 'localVar + ((4))'.
	intervalToExtract _ self intervalOfCode: codeToExtract.
	sourceCodeOfNewMethod _ self newMethodDefinitionWith: '^ ', codeToExtract.
	originalSelector _ self selectorOfMethodToExtractCodeFrom.
	updatedSourceCodeOfOriginalMethod _ self updatedSourceCodeAfterExtracting: intervalToExtract.

	self applyExtractMethodOf: intervalToExtract on: #category.

	self assertClassHasDefined: newUnarySelector withBody: sourceCodeOfNewMethod inCategory: #category.
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

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 19:17:39'!
test04NewSelectorShouldNotStartWithANumber

	self
		creationWithSelectorNamed: #'2selector'
		failsWith: ExtractMethodNewSelectorPrecondition invalidStartingCharacterOfNewSelectorErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 19:22:36'!
test05NewUnarySelectorShouldNotStartWithASymbol

	self
		creationWithSelectorNamed: #-
		failsWith: ExtractMethodNewSelectorPrecondition invalidStartingCharacterOfNewSelectorErrorMessage! !

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

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 18:59:22'!
test08IntervalToExtractShouldNotContainAReturnExpression

	self
		creationOnInterval: (self intervalOfCode: '^ localVar + ((4))')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 18:07:07'!
test10IntervalToExtractDoesNotContainsPartOfTheOriginalSelector

	| intervalToExtract |
	intervalToExtract  _ self intervalOfCode: self selectorOfMethodToExtractCodeFrom asString.
	self
		creationOnInterval: intervalToExtract
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 18:06:21'!
test11IntervalToExtractDoesNotContainsPartOfLocalVariablesDefinition

	self
		creationOnInterval: (self intervalOfCode: '| localVar |')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 18:06:35'!
test12IntervalToExtractDoesNotContainsPartOfPragmasDefinition

	self
		creationOnInterval: (self intervalOfCode: '<anotherAnnoyingPragma>')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 6/2/2019 18:59:26'!
test13IntervalToExtractShouldBeAValidSmalltalkExpression

	self
		creationOnInterval: (self intervalOfCode: '+ ((4))')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/25/2019 21:16:38'!
test14ItIsNotPossibleToExtractTheLeftSideOfAnAssignment

	| firstOccurrence secondOccurrence intervalToExtract |
	firstOccurrence _ self sourceCodeOfMethodToExtractCodeFrom
		indexOfSubCollection: 'localVar' startingAt: 1.
	secondOccurrence _ self sourceCodeOfMethodToExtractCodeFrom
		indexOfSubCollection: 'localVar' startingAt: firstOccurrence + 1.
	intervalToExtract _ secondOccurrence toSelfPlus: 'localVar' size.
	self
		creationOnInterval: intervalToExtract
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 5/28/2019 00:27:43'!
test16CanNotExtractPartOfALiteral

	self
		creationOnInterval: (self intervalOfCode: 'true')
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/7/2019 19:17:47'!
test23CanNotExtractWithAnInvalidInterval

	self
		creationOnInterval: (10 to: 9)
		failsWith: ExtractMethod noSelectionErrorMessage! !
