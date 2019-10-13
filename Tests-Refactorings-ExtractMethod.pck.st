'From Cuis 5.0 [latest update: #3880] on 13 October 2019 at 7:03:05 pm'!
'Description Tests for the Extract Method refactoring.'!
!provides: 'Tests-Refactorings-ExtractMethod' 1 18!
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


!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 9/28/2019 00:49:10'!
assertClassHasDefined: aSelector withBody: newSourceCode

	self
		assert: newSourceCode
		equals: (classToRefactor >> aSelector) sourceCode! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 6/23/2019 18:30:02'!
assertClassHasDefined: aSelector withBody: newSourceCode inCategory: aCategory

	self assertClassHasDefined: aSelector withBody: newSourceCode.
	self assert: aCategory equals: (classToRefactor >> aSelector) category! !

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

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 9/28/2019 00:46:57'!
extract: codeToExtract from: originalCode named: newMessage defines: newCode andUpdates: updatedCode

	| originalSelector category |
	category _ #category.
	originalSelector _ classToRefactor compile: originalCode classified: category.

	(ExtractMethod
		fromInterval: (self intervalOf: codeToExtract locatedIn: originalCode)
		of: classToRefactor >> originalSelector
		to: newMessage
		categorizedAs: category) apply.

	self
		assertClassHasDefined: originalSelector withBody: updatedCode inCategory: category;
		assertClassHasDefined: newMessage selector withBody: newCode inCategory: category! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 9/28/2019 01:10:34'!
tryingToExtract: someCode from: anExistingSourceCode failsWith: aRefactoringErrorMessage

	| existingSelector |
	existingSelector _ classToRefactor compile: anExistingSourceCode.

	self
		creationWithSelectorNamed: #aValidSelector
		onInterval: (self intervalOf: someCode locatedIn: anExistingSourceCode)
		ofMethod: classToRefactor >> existingSelector
		failsWith: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 9/22/2019 22:30:00'!
tryingToExtractOnInterval: anIntervalToExtract failsWith: aRefactoringErrorMessage

	self
		creationWithSelectorNamed: #aValidSelector
		onInterval: anIntervalToExtract
		ofMethod: self methodToExtractCodeFrom
		failsWith: aRefactoringErrorMessage! !

!ExtractMethodTest methodsFor: 'assertions' stamp: 'RNG 9/28/2019 01:05:46'!
tryingToExtractWithSelectorNamed: aSelectorName failsWith: aRefactoringErrorMessage

	| originalSource |
	originalSource _ 'm1 ^ 8'.
	classToRefactor compile: originalSource.

	self
		creationWithSelectorNamed: aSelectorName
		onInterval: (self intervalOf: '8' locatedIn: originalSource)
		ofMethod: classToRefactor >> #m1
		failsWith: aRefactoringErrorMessage! !

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

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 5/12/2019 23:25:05'!
selectorOfMethodToExtractCodeFrom

	^ #mExtractMethodExample:! !

!ExtractMethodTest methodsFor: 'method and source code helpers' stamp: 'RNG 9/8/2019 18:40:40'!
sourceCodeOfMethodToExtractCodeFrom

	^ self selectorOfMethodToExtractCodeFrom, ' anArgument

	<anAnnoyingPragma>
	| localVar |
	<anotherAnnoyingPragma>
	self m1.
	self m2: ''hey true''.
	self m3: anArgument , ''^ 21''.
	localVar _ Set with: ''hello''.
	localVar := #($x $y $z) size and: [ (9) * 3 ].
	^ localVar + ((4))'! !

!ExtractMethodTest methodsFor: 'refactoring helpers' stamp: 'RNG 9/27/2019 23:24:08'!
intervalOf: aPieceOfSourceCode locatedIn: sourceCode

	| interval |
	interval _ sourceCode intervalOfSubCollection: aPieceOfSourceCode.
	^ interval first to: interval last - 1! !

!ExtractMethodTest methodsFor: 'set up' stamp: 'RNG 9/28/2019 01:16:48'!
setUp

	super setUp.
	classToRefactor _ self createClassNamed: self classToRefactorName.
	self compileMethodToExtractCodeFrom.! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/28/2019 00:42:11'!
test09ExtractingALiteralCreatesANewMethodAndChangesExistingCodeToCallThatNewMethod

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '4'.
	originalCode _ 'm1 ^ ' , codeToExtract.
	newMethodCode _ 'm2

	^ ' , codeToExtract.
	updatedCode _ 'm1 ^ self m2'.

	self
		extract: codeToExtract from: originalCode named: (Message selector: #m2)
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/28/2019 00:59:00'!
test15ExtractingAListOfStatementsCreatesANewMethodWithoutReturn

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ 'self m3.
	self m4: 5'.
	originalCode _ 'm1 ' , codeToExtract.
	newMethodCode _ 'm2

	', codeToExtract.
	updatedCode _ 'm1 self m2'.

	self
		extract: codeToExtract from: originalCode named: (Message selector: #m2)
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/28/2019 00:41:57'!
test17AStringContainingTheReturnCharacterCanBeExtracted
	"this is to make sure the return is found using AST logic, not by text"

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '''^ 3'' size'.
	originalCode _ 'm1 ^ ' , codeToExtract.
	newMethodCode _ 'm2

	^ ' , codeToExtract.
	updatedCode _ 'm1 ^ self m2'.

	self
		extract: codeToExtract from: originalCode named: (Message selector: #m2)
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/28/2019 00:57:28'!
test18ExtractingAListOfStatementsIncludingDotsRemovesThemAndContinuesWithMethodExtraction

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '
	self m3.
	self m4: 5.'.
	originalCode _ 'm1
	' , codeToExtract.
	newMethodCode _ 'm2

	self m3.
	self m4: 5'.
	updatedCode _ 'm1
	
	self m2.'.

	self
		extract: codeToExtract from: originalCode named: (Message selector: #m2)
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/28/2019 00:41:45'!
test19ASelectionContainingAdditionalParenthesesAtTheBeginningAndOrEndCanBeExtracted

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '((42))'.
	originalCode _ 'm1 ^ ' , codeToExtract.
	newMethodCode _ 'm2

	^ 42'.
	updatedCode _ 'm1 ^ ((self m2))'.

	self
		extract: codeToExtract from: originalCode named: (Message selector: #m2)
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/28/2019 00:50:25'!
test20ASelectionContainingALocalVariableIsParameterizedOnTheExtractedMessage

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ 'local + 3'.
	originalCode _ 'm1 | local | ^ ' , codeToExtract.
	newMethodCode _ 'm2: local

	^ ' , codeToExtract.
	updatedCode _ 'm1 | local | ^ self m2: local'.

	self
		extract: codeToExtract from: originalCode named: (Message selector: #m2: arguments: #('local'))
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/28/2019 00:41:34'!
test21ASelectionContainingAdditionalParenthesesOnOneSideCanBeExtractedAndItIsNotTrimmed

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '(9) * 3'.
	originalCode _ 'm1 ^ ' , codeToExtract.
	newMethodCode _ 'm2

	^ ' , codeToExtract.
	updatedCode _ 'm1 ^ self m2'.

	self
		extract: codeToExtract from: originalCode named: (Message selector: #m2)
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/28/2019 00:53:25'!
test22ItIsPossibleToExtractTheLastExpressionOfAMethod

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ 'localVar + ((4))'.
	originalCode _ 'm1 | localVar | ^ ' , codeToExtract.
	newMethodCode _ 'm2: localVar

	^ ' , codeToExtract.
	updatedCode _ 'm1 | localVar | ^ self m2: localVar'.

	self
		extract: codeToExtract from: originalCode named: (Message selector: #m2: arguments: #('localVar'))
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/28/2019 00:41:18'!
test26ItIsPossibleToExtractAnEntireBlockIncludingALocalAssignment

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '[ |something| something _ 3 ]'.
	originalCode _ 'm1 ^ ' , codeToExtract.
	newMethodCode _ 'm2

	^ ' , codeToExtract.
	updatedCode _ 'm1 ^ self m2'.

	self
		extract: codeToExtract from: originalCode named: (Message selector: #m2)
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 9/28/2019 01:19:37'!
test27ItIsPossibleToExtractExpressionsWithOptimizedSelectors

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '2 ifNil: [ #boo ] ifNotNil: [ #yay ]'.
	originalCode _ 'm1 ^ ' , codeToExtract.
	newMethodCode _ 'm2

	^ ' , codeToExtract.
	updatedCode _ 'm1 ^ self m2'.

	self
		extract: codeToExtract from: originalCode named: (Message selector: #m2)
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - successful' stamp: 'RNG 10/13/2019 18:25:35'!
test29ExtractingABinaryExpressionToAKeywordMessageIntroducesParenthesesToNotBreakOriginalPrecedence

	| codeToExtract newMethodCode originalCode updatedCode |
	codeToExtract _ '2 + arg'.
	originalCode _ 'm1: arg ^ ' , codeToExtract , ' * 3'.
	newMethodCode _ 'm2: arg

	^ ' , codeToExtract.
	updatedCode _ 'm1: arg ^ (self m2: arg) * 3'.

	self
		extract: codeToExtract from: originalCode named: (Message selector: #m2: arguments: #('arg'))
		defines: newMethodCode andUpdates: updatedCode! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:29:34'!
test01NewSelectorShouldNotBeEmpty

	self
		tryingToExtractWithSelectorNamed: #''
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorCanNotBeEmptyErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:29:34'!
test02NewSelectorShouldNotContainSeparators

	self
		tryingToExtractWithSelectorNamed: #'my selector'
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorCanNotContainSeparatorsErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:29:34'!
test03NewSelectorShouldNotBeAlreadyDefinedInTheClass

	self
		tryingToExtractWithSelectorNamed: self selectorOfMethodToExtractCodeFrom
		failsWith: ExtractMethodNewSelectorPrecondition newSelectorAlreadyDefinedOnTheClassErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:29:34'!
test04NewSelectorShouldNotStartWithANumber

	self
		tryingToExtractWithSelectorNamed: #'2selector'
		failsWith: ExtractMethodNewSelectorPrecondition invalidStartingCharacterOfNewSelectorErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:29:34'!
test05NewUnarySelectorShouldNotStartWithASymbol

	self
		tryingToExtractWithSelectorNamed: #-
		failsWith: ExtractMethodNewSelectorPrecondition invalidStartingCharacterOfNewSelectorErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test06IntervalToExtractIsNotBeforeMethodSourceCodeBoundaries

	self
		tryingToExtractOnInterval: (-1 to: 2)
		failsWith: ExtractMethod outOfBoundsSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test07IntervalToExtractIsNotAfterMethodSourceCodeBoundaries

	self
		tryingToExtractOnInterval: (1 to: self sourceCodeOfMethodToExtractCodeFrom size + 2)
		failsWith: ExtractMethod outOfBoundsSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/28/2019 01:10:40'!
test08IntervalToExtractShouldNotContainAReturnExpression

	self
		tryingToExtract: '^ localVar + ((4))'
		from: 'm1 ^ localVar + ((4))'
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/28/2019 01:11:35'!
test10IntervalToExtractDoesNotContainsPartOfTheOriginalSelector

	self
		tryingToExtract: 'm1 ^ 8'
		from: 'm1 ^ 8'
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/28/2019 01:11:58'!
test11IntervalToExtractDoesNotContainsPartOfLocalVariablesDefinition

	self
		tryingToExtract: '| localVar |'
		from: 'm1 | localVar | ^ localVar + 3'
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/28/2019 01:12:17'!
test12IntervalToExtractDoesNotContainsPartOfPragmasDefinition

	self
		tryingToExtract: '<annoyingPragma>'
		from: 'm1 <annoyingPragma>'
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/28/2019 01:12:32'!
test13IntervalToExtractShouldBeAValidSmalltalkExpression

	self
		tryingToExtract: '+ ((4))'
		from: 'm1 ^ 3 + ((4))'
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/28/2019 01:13:00'!
test14ItIsNotPossibleToExtractTheLeftSideOfAnAssignment

	| firstOccurrence secondOccurrence intervalToExtract |
	firstOccurrence _ self sourceCodeOfMethodToExtractCodeFrom
		indexOfSubCollection: 'localVar' startingAt: 1.
	secondOccurrence _ self sourceCodeOfMethodToExtractCodeFrom
		indexOfSubCollection: 'localVar' startingAt: firstOccurrence + 1.
	intervalToExtract _ secondOccurrence toSelfPlus: 'localVar' size.
	self
		tryingToExtractOnInterval: intervalToExtract
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/28/2019 01:13:13'!
test16CanNotExtractPartOfALiteral

	self
		tryingToExtract: 'true'
		from: 'm1 ^ ''hey true'''
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:30:00'!
test23CanNotExtractWithAnInvalidInterval

	self
		tryingToExtractOnInterval: (10 to: 9)
		failsWith: ExtractMethod noSelectionErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/28/2019 01:13:36'!
test24ItIsNotPossibleToExtractAnIntervalIncludingATemporaryAssignmentExpression

	self
		tryingToExtract: 'localVar _ 8'
		from: 'm1 | localVar | localVar _ 8'
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/22/2019 22:29:34'!
test25NewUnarySelectorShouldNotContainInvalidCharacters

	self
		tryingToExtractWithSelectorNamed: 'hola)' asSymbol
		failsWith: ExtractMethodNewSelectorPrecondition invalidCharacterInsideNewSelectorErrorMessage! !

!ExtractMethodTest methodsFor: 'tests - validations' stamp: 'RNG 9/28/2019 01:20:52'!
test28ItIsNotPossibleToExtractALocalVariableInsideOfItsDeclaration

	self
		tryingToExtract: 'localVar'
		from: 'm1 | localVar | ^ #foo'
		failsWith: ExtractMethod selectedCodeInvalidForExtractErrorMessage! !
