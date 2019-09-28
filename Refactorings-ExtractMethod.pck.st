'From Cuis 5.0 [latest update: #3880] on 28 September 2019 at 1:42:33 am'!
'Description Extract Method refactoring.'!
!provides: 'Refactorings-ExtractMethod' 1 22!
SystemOrganization addCategory: #'Refactorings-ExtractMethod'!


!classDefinition: #ExtractMethod category: #'Refactorings-ExtractMethod'!
Refactoring subclass: #ExtractMethod
	instanceVariableNames: 'intervalToExtract categoryOfNewSelector newMessage extractedSourceCode existingMethod'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethod class' category: #'Refactorings-ExtractMethod'!
ExtractMethod class
	instanceVariableNames: ''!

!classDefinition: #ExtractMethodApplier category: #'Refactorings-ExtractMethod'!
RefactoringApplier subclass: #ExtractMethodApplier
	instanceVariableNames: 'intervalToExtract methodToExtractCodeFrom newSelector newMessageArguments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodApplier class' category: #'Refactorings-ExtractMethod'!
ExtractMethodApplier class
	instanceVariableNames: ''!

!classDefinition: #ExtractMethodNewSelectorPrecondition category: #'Refactorings-ExtractMethod'!
RefactoringPrecondition subclass: #ExtractMethodNewSelectorPrecondition
	instanceVariableNames: 'selectorToValidate classToDefineSelector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodNewSelectorPrecondition class' category: #'Refactorings-ExtractMethod'!
ExtractMethodNewSelectorPrecondition class
	instanceVariableNames: ''!

!classDefinition: #ExtractMethodEditorMenu category: #'Refactorings-ExtractMethod'!
Object subclass: #ExtractMethodEditorMenu
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodEditorMenu class' category: #'Refactorings-ExtractMethod'!
ExtractMethodEditorMenu class
	instanceVariableNames: ''!

!classDefinition: #ExtractMethodExpressionValidation category: #'Refactorings-ExtractMethod'!
Object subclass: #ExtractMethodExpressionValidation
	instanceVariableNames: 'method intervalToExtract methodNode sourceCode initialNode finalNode initialNodeAncestors finalNodeAncestors'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodExpressionValidation class' category: #'Refactorings-ExtractMethod'!
ExtractMethodExpressionValidation class
	instanceVariableNames: ''!

!classDefinition: #ExtractMethodIntervalTrimmer category: #'Refactorings-ExtractMethod'!
Object subclass: #ExtractMethodIntervalTrimmer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Refactorings-ExtractMethod'!
!classDefinition: 'ExtractMethodIntervalTrimmer class' category: #'Refactorings-ExtractMethod'!
ExtractMethodIntervalTrimmer class
	instanceVariableNames: ''!


!ExtractMethod methodsFor: 'initialization' stamp: 'RNG 6/23/2019 20:29:44'!
initializeExtractedSourceCode

	extractedSourceCode _ existingMethod sourceCode
		copyFrom: intervalToExtract first
		to: intervalToExtract last! !

!ExtractMethod methodsFor: 'initialization' stamp: 'RNG 6/23/2019 20:29:44'!
initializeFrom: anIntervalToExtract of: aMethodToExtractCodeFrom to: aNewMessage in: aCategory 

	intervalToExtract _ anIntervalToExtract.
	existingMethod _ aMethodToExtractCodeFrom.
	newMessage _ aNewMessage.
	categoryOfNewSelector _ aCategory.
	self initializeExtractedSourceCode.! !

!ExtractMethod methodsFor: 'applying' stamp: 'RNG 4/29/2019 00:45:18'!
apply

	self
		defineExtractedMethod;
		changeExistingMethod! !

!ExtractMethod methodsFor: 'applying' stamp: 'RNG 6/23/2019 20:29:44'!
changeExistingMethod

	self sourceClass
		compile: self updatedSourceCodeOfExistingMethod
		classified: existingMethod category! !

!ExtractMethod methodsFor: 'applying' stamp: 'RNG 6/23/2019 20:25:44'!
defineExtractedMethod

 	self sourceClass
		compile: self newMethodSourceCode
		classified: categoryOfNewSelector! !

!ExtractMethod methodsFor: 'private - source code' stamp: 'RNG 6/23/2019 19:57:48'!
newMessageString

	^ newMessage fullName! !

!ExtractMethod methodsFor: 'private - source code' stamp: 'RNG 9/19/2019 22:04:14'!
newMethodSourceCode

	^ self newMessageString
	, self startingMethodIdentation
	, self returnCharacterIfNeeded
	, extractedSourceCode! !

!ExtractMethod methodsFor: 'private - source code' stamp: 'RNG 6/23/2019 20:26:40'!
returnCharacterIfNeeded

	| parseNode |
	parseNode _ Parser parse: extractedSourceCode class: self sourceClass noPattern: true.
	^ parseNode block statements size = 1 ifTrue: [ '^ ' ] ifFalse: [ '' ]! !

!ExtractMethod methodsFor: 'private - source code' stamp: 'RNG 6/23/2019 20:29:44'!
sourceClass

	^ existingMethod methodClass! !

!ExtractMethod methodsFor: 'private - source code' stamp: 'RNG 9/19/2019 22:04:09'!
startingMethodIdentation

	^ String lfString , String lfString , String tab! !

!ExtractMethod methodsFor: 'private - source code' stamp: 'RNG 6/23/2019 20:29:44'!
updatedSourceCodeOfExistingMethod

	^ existingMethod sourceCode
		copyReplaceFrom: intervalToExtract first
		to: intervalToExtract last
		with: 'self ', self newMessageString! !

!ExtractMethod class methodsFor: 'instance creation' stamp: 'RNG 6/23/2019 18:24:36'!
fromInterval: anIntervalToExtract of: aMethodToExtractCodeFrom to: newMessage categorizedAs: aCategory 

	| trimmedIntervalToExtract |
	trimmedIntervalToExtract _ ExtractMethodIntervalTrimmer
		trim: anIntervalToExtract locatedIn: aMethodToExtractCodeFrom sourceCode.
	self
		ensure: newMessage selector canBeDefinedIn: aMethodToExtractCodeFrom methodClass;
		ensure: trimmedIntervalToExtract isValidIntervalOn: aMethodToExtractCodeFrom.

	^ self new
		initializeFrom: trimmedIntervalToExtract
		of: aMethodToExtractCodeFrom
		to: newMessage
		in: aCategory! !

!ExtractMethod class methodsFor: 'validations' stamp: 'RNG 5/4/2019 22:40:07'!
ensure: aSelector canBeDefinedIn: aClass 

	ExtractMethodNewSelectorPrecondition valueFor: aSelector on: aClass! !

!ExtractMethod class methodsFor: 'validations' stamp: 'RNG 9/7/2019 19:23:53'!
ensure: anIntervalToExtract isValidIntervalOn: aMethodToExtractCodeFrom 

	self isNotEmpty: anIntervalToExtract
		:: ifFalse: [ self signalNoSelectedCodeError ].
	self is: anIntervalToExtract withinBoundsOf: aMethodToExtractCodeFrom sourceCode
		:: ifFalse: [ self signalOutOfBoundsIntervalError ].
	self method: aMethodToExtractCodeFrom containsAValidExpressionOn: anIntervalToExtract
		:: ifFalse: [ self signalSelectedCodeIsInvalidForExtractError ].! !

!ExtractMethod class methodsFor: 'error messages' stamp: 'RNG 9/7/2019 19:20:33'!
noSelectionErrorMessage

	^ 'Please select some code for extraction'! !

!ExtractMethod class methodsFor: 'error messages' stamp: 'RNG 4/20/2019 21:53:45'!
outOfBoundsSelectionErrorMessage

	^ 'The source code selection interval is out of bounds'! !

!ExtractMethod class methodsFor: 'error messages' stamp: 'RNG 5/12/2019 23:42:45'!
selectedCodeInvalidForExtractErrorMessage

	^ 'The selected code can not be extracted to a method'! !

!ExtractMethod class methodsFor: 'exceptions' stamp: 'RNG 9/7/2019 19:24:57'!
signalNoSelectedCodeError

	self refactoringError: self noSelectionErrorMessage! !

!ExtractMethod class methodsFor: 'exceptions' stamp: 'RNG 4/20/2019 21:53:24'!
signalOutOfBoundsIntervalError

	self refactoringError: self outOfBoundsSelectionErrorMessage! !

!ExtractMethod class methodsFor: 'exceptions' stamp: 'RNG 5/12/2019 23:54:19'!
signalSelectedCodeIsInvalidForExtractError

	self refactoringError: self selectedCodeInvalidForExtractErrorMessage! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 5/28/2019 00:22:21'!
is: anIntervalToExtract withinBoundsOf: aSourceCode

	^ anIntervalToExtract first >= 1 and: [ anIntervalToExtract last <= aSourceCode size ]! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 9/7/2019 19:26:15'!
isNotEmpty: anInterval 

	^ anInterval first <= anInterval last! !

!ExtractMethod class methodsFor: 'validations - private' stamp: 'RNG 7/6/2019 20:06:09'!
method: aMethod containsAValidExpressionOn: anIntervalToExtract
	
	^ (ExtractMethodExpressionValidation for: anIntervalToExtract of: aMethod) passed! !

!ExtractMethodApplier methodsFor: 'initialization' stamp: 'RNG 6/23/2019 19:08:58'!
initializeFor: anIntervalToExtract of: aMethodToExtractCodeFrom

	intervalToExtract _ anIntervalToExtract.
	methodToExtractCodeFrom _ aMethodToExtractCodeFrom.
	newMessageArguments _ Dictionary new! !

!ExtractMethodApplier methodsFor: 'refactoring - changes' stamp: 'RNG 5/13/2019 02:17:27'!
showChanges! !

!ExtractMethodApplier methodsFor: 'refactoring - creation' stamp: 'RNG 6/23/2019 20:11:34'!
createRefactoring

	^ ExtractMethod
		fromInterval: intervalToExtract
		of: methodToExtractCodeFrom
		to: self buildNewMessage
		categorizedAs: methodToExtractCodeFrom category! !

!ExtractMethodApplier methodsFor: 'refactoring - parameters request' stamp: 'RNG 9/10/2019 18:23:12'!
requestRefactoringParameters

	| parseNodesToParameterize initialAnswer userAnswer |
	parseNodesToParameterize _ self parseNodesToParameterize.
	initialAnswer _ self buildInitialSelectorAnswer: parseNodesToParameterize.
	userAnswer _ self request: 'New method name:' initialAnswer: initialAnswer.

	parseNodesToParameterize
		ifEmpty: [ self saveUnarySelector: userAnswer ]
		ifNotEmpty: [ self saveBinaryOrKeywordSelector: userAnswer withArguments: parseNodesToParameterize ]! !

!ExtractMethodApplier methodsFor: 'private - new message' stamp: 'RNG 9/8/2019 20:39:42'!
buildNewMessage

	^ Message
		selector: newSelector
		arguments: self newMessageArgumentNames! !

!ExtractMethodApplier methodsFor: 'private - new message' stamp: 'RNG 9/8/2019 20:39:33'!
newMessageArgumentNames

	^ newMessageArguments values collect: [ :parseNode | parseNode name ]! !

!ExtractMethodApplier methodsFor: 'private - new message' stamp: 'RNG 9/8/2019 20:05:08'!
saveUnarySelector: userAnswer

	^ newSelector _ userAnswer asSymbol! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/10/2019 17:26:45'!
blockNodesEnclosingIntervalToExtract

	| nodes |
	nodes _ Set new.
	methodToExtractCodeFrom methodNode completeSourceRangesDo: [ :parseNode :sourceRanges |
		parseNode isBlockNode
		:: and: [ self intervalToExtractIsCoveredByAnyOf: sourceRanges ]
		:: ifTrue: [ nodes add: parseNode ] ].
	^ nodes! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/10/2019 18:31:16'!
buildInitialSelectorAnswer: parseNodesToParameterize
	"builds a selector with the shape of #m1 if unary, or #m1: something m2: else if it has args"

	^ parseNodesToParameterize
		ifEmpty: [ self formatAsKeyword: 'm1' ]
		ifNotEmpty: [ parseNodesToParameterize
			inject: ''
			into: [ :partialSelector :parseNode |
				| currentKeyword |
				currentKeyword _ 'm' , (parseNodesToParameterize indexOf: parseNode) asString , ': '.
				partialSelector
				, (self formatAsKeyword: currentKeyword)
				, (self formatAsMethodArgument: parseNode name)
				, String newLineString ] ]! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/10/2019 17:30:18'!
definedInOuterScope: parseNode

	^ self nodesThatAddVariablesToScope
		anySatisfy: [ :node | node hasTemporaryOrArgumentNamed: parseNode name ]! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/10/2019 18:30:31'!
formatAsKeyword: aKeyword

	^ Text
		string: aKeyword
		attributes: (SHTextStylerST80 attributesFor: #patternKeyword)! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/10/2019 18:31:37'!
formatAsMethodArgument: aMethodArgumentName

	^ Text
		string: aMethodArgumentName
		attributes: (SHTextStylerST80 attributesFor: #methodArg)! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/10/2019 17:26:57'!
intervalToExtractIsCoveredByAnyOf: sourceRanges

	^ sourceRanges anySatisfy: [ :sourceRange |
		sourceRange first < intervalToExtract first
			and: [ sourceRange last > intervalToExtract last ] ]! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/10/2019 17:30:00'!
nodesThatAddVariablesToScope

	^ (Set with: methodToExtractCodeFrom methodNode) , self blockNodesEnclosingIntervalToExtract! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/10/2019 17:15:34'!
parseNodesToParameterize

	| parseNodesFound |
	parseNodesFound _ OrderedCollection new.
	methodToExtractCodeFrom methodNode completeSourceRangesDo: [ :parseNode :sourceRanges |
		(self shouldBeParameterized: parseNode appearingIn: sourceRanges)
			ifTrue: [ parseNodesFound add: parseNode ]
	].
	^ parseNodesFound! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/8/2019 20:51:17'!
saveBinaryOrKeywordSelector: userAnswer withArguments: parseNodesToParameterize

	self saveMessageArgumentsForEach: parseNodesToParameterize using: userAnswer.
	newSelector _ '' join: (self selectorTokensOf: userAnswer) :: asSymbol.! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/19/2019 22:11:12'!
saveMessageArgumentsForEach: parseNodesToParameterize using: userAnswer

	| newSelectorKeywords |
	newSelectorKeywords _ self selectorTokensOf: userAnswer.
	self validateRequiredParameters: parseNodesToParameterize haveACorrespondingKeywordIn: newSelectorKeywords.
	parseNodesToParameterize withIndexDo: [ :parseNode :index |
		newMessageArguments at: (newSelectorKeywords at: index) put: parseNode ]! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/8/2019 20:55:52'!
selectorTokensOf: userAnswer
	"this selects the pieces of strings before each $:"

	^ (userAnswer findTokens: ':') allButLast
		collect: [ :tok | (tok findTokens: Character separators) last , ':' ]! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/10/2019 17:16:48'!
shouldBeParameterized: parseNode appearingIn: sourceRanges

	^ sourceRanges anySatisfy: [ :sourceRange | intervalToExtract includes: sourceRange first ]
		:: and: [ parseNode isTempOrArg ]
		:: and: [ self definedInOuterScope: parseNode ]! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/19/2019 20:43:42'!
signalExtractMethodWithWrongNumberOfArgumentsError

	^ ExtractMethod refactoringError: 'The number of arguments in the entered selector is not correct'! !

!ExtractMethodApplier methodsFor: 'private - parameterizing' stamp: 'RNG 9/19/2019 22:11:43'!
validateRequiredParameters: parseNodesToParameterize haveACorrespondingKeywordIn: newSelectorKeywords

	newSelectorKeywords size = parseNodesToParameterize size
		ifFalse: [ self signalExtractMethodWithWrongNumberOfArgumentsError ]! !

!ExtractMethodApplier class methodsFor: 'pre-conditions' stamp: 'RNG 5/13/2019 02:06:39'!
assertCanApplyRefactoringOn: aMethodToExtractCodeFrom at: anIntervalToExtract

	ExtractMethod
		ensure: anIntervalToExtract
		isValidIntervalOn: aMethodToExtractCodeFrom! !

!ExtractMethodApplier class methodsFor: 'instance creation' stamp: 'RNG 6/2/2019 18:56:51'!
for: anIntervalToExtract of: aMethodToExtractCodeFrom

	| trimmedIntervalToExtract sourceCode |
	sourceCode _ aMethodToExtractCodeFrom sourceCode.
	trimmedIntervalToExtract _ ExtractMethodIntervalTrimmer trim: anIntervalToExtract locatedIn: sourceCode.
	
	self assertCanApplyRefactoringOn: aMethodToExtractCodeFrom at: trimmedIntervalToExtract.

	^ self new initializeFor: trimmedIntervalToExtract of: aMethodToExtractCodeFrom! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating' stamp: 'RNG 9/10/2019 18:52:36'!
value

	self
		assertNewSelectorIsNotEmpty;
		assertNewSelectorDoesNotContainSeparators;
		assertNewSelectorBeginsWithAValidCharacter;
		assertNewSelectorContainsOnlyValidCharacters;
		assertNewSelectorIsNotAlreadyDefinedInTheClass! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'initialization' stamp: 'RNG 4/18/2019 16:04:44'!
initializeFor: aSelectorToValidate on: aClassToDefineSelector

	selectorToValidate _ aSelectorToValidate.
	classToDefineSelector _ aClassToDefineSelector! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 6/2/2019 19:20:09'!
signalNewSelectorBeginsWithAnInvalidCharacter

	self refactoringError: self class invalidStartingCharacterOfNewSelectorErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 4/18/2019 15:11:55'!
signalNewSelectorCanNotBeEmptyError

	self refactoringError: self class newSelectorCanNotBeEmptyErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 5/5/2019 12:22:02'!
signalNewSelectorCanNotContainSeparatorsError

	self refactoringError: self class newSelectorCanNotContainSeparatorsErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 9/10/2019 18:53:55'!
signalNewSelectorContainsInvalidCharactersError

	self refactoringError: self class invalidCharacterInsideNewSelectorErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'exceptions' stamp: 'RNG 5/5/2019 12:22:40'!
signalNewSelectorIsAlreadyDefinedInTheClassError

	self refactoringError: self class newSelectorAlreadyDefinedOnTheClassErrorMessage! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 6/2/2019 19:21:50'!
assertNewSelectorBeginsWithAValidCharacter

	selectorToValidate first isValidStartOfIdentifiers 
		ifFalse: [ self signalNewSelectorBeginsWithAnInvalidCharacter ]! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 9/10/2019 19:10:00'!
assertNewSelectorContainsOnlyValidCharacters

	(selectorToValidate isValidSelector)
		ifFalse: [ self signalNewSelectorContainsInvalidCharactersError ]! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 4/18/2019 15:13:52'!
assertNewSelectorDoesNotContainSeparators

	(selectorToValidate anySatisfy: [ :character | character isSeparator ])
		ifTrue: [ self signalNewSelectorCanNotContainSeparatorsError ]! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 9/8/2019 20:49:51'!
assertNewSelectorIsNotAlreadyDefinedInTheClass

	(classToDefineSelector includesSelector: selectorToValidate)
		ifTrue: [ self signalNewSelectorIsAlreadyDefinedInTheClassError ]! !

!ExtractMethodNewSelectorPrecondition methodsFor: 'evaluating - private' stamp: 'RNG 5/5/2019 12:23:16'!
assertNewSelectorIsNotEmpty

	selectorToValidate ifEmpty: [ self signalNewSelectorCanNotBeEmptyError ]! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 9/10/2019 18:51:15'!
invalidCharacterInsideNewSelectorErrorMessage

	^ 'New selector should only contain letters, numbers or _'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 6/2/2019 19:18:14'!
invalidStartingCharacterOfNewSelectorErrorMessage

	^ 'New selector should begin with a lowercase letter or _'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:58:58'!
newSelectorAlreadyDefinedOnTheClassErrorMessage

	^ 'New selector is already defined on this class'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 14:40:21'!
newSelectorCanNotBeEmptyErrorMessage

	^ 'New selector can not be empty'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'error messages' stamp: 'RNG 4/18/2019 15:05:41'!
newSelectorCanNotContainSeparatorsErrorMessage

	^ 'New selector can not contain separators'! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'instance creation' stamp: 'RNG 4/18/2019 16:01:43'!
for: aSelectorToValidate on: aClass 

	^ self new initializeFor: aSelectorToValidate on: aClass! !

!ExtractMethodNewSelectorPrecondition class methodsFor: 'evaluating' stamp: 'RNG 4/18/2019 15:59:44'!
valueFor: aSelectorToValidate on: aClass

	^ (self for: aSelectorToValidate on: aClass) value! !

!ExtractMethodEditorMenu class methodsFor: 'shortcuts' stamp: 'RNG 9/8/2019 20:56:48'!
smalltalkEditorCmdShortcutsSpec

	^#(#($K #extractMethod: 'Extracts the selected code into a separate method'))! !

!ExtractMethodEditorMenu class methodsFor: 'menu items' stamp: 'RNG 9/8/2019 20:56:43'!
smalltalkEditorMenuOptions

	^`{
		{
				#itemGroup 		-> 		35.
				#itemOrder 		-> 		20.
				#label 			-> 		'Extract Method... (K)'.
				#selector 		-> 		#extractMethod.
				#icon 			-> 		#saveAsIcon
		} asDictionary
	}`! !

!ExtractMethodExpressionValidation methodsFor: 'validation' stamp: 'RNG 9/8/2019 18:42:38'!
passed

	methodNode _ method methodNode.
	sourceCode _ method sourceCode.
	initialNodeAncestors  _ methodNode parseNodesPathAt: intervalToExtract first ifAbsent: [ ^ false].
	finalNodeAncestors _ methodNode parseNodesPathAt: intervalToExtract last ifAbsent: [ ^ false ].
	initialNode _ initialNodeAncestors first.
	finalNode _ finalNodeAncestors first.

	^ self intervalCoversCompleteAstNodes
		:: and: [ self containsValidNodes ]
		:: and: [ self startAndEndParseNodesAreTheSame
			:: or: [ self startAndEndNodesShareAParentNode ]
			:: or: [ self intervalMatchesBeginningOfStatement and: [ self intervalMatchesEndOfStatement ] ] ]! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 9/28/2019 01:21:30'!
containsValidNodes

	^ self isNotLeftSideOfAssignment
		:: and: [ self thereAreNoLocalVariableAssignments ]
		:: and: [ self thereAreNoReturnExpressions ]
		:: and: [ self isNotATempDeclaration ]! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 9/19/2019 22:16:05'!
intervalCoversCompleteAstNodes 

	^ (self trimmed: (initialNode value first to: finalNode value last)) = intervalToExtract! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 7/9/2019 15:59:28'!
intervalMatchesBeginningOfStatement 

	^ initialNodeAncestors last value first = intervalToExtract first! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 7/9/2019 15:59:45'!
intervalMatchesEndOfStatement

	^ finalNodeAncestors last value last = intervalToExtract last! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 9/28/2019 00:05:30'!
isDeclaredWithinIntervalToExtract: aVariableNode

	^ methodNode
		allParseNodesWithin: intervalToExtract
		satisfy: [ :parseNode | parseNode isBlockNode
			and: [ parseNode temporaries includes: aVariableNode ] ]! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 9/8/2019 21:14:54'!
isLeftSideOfAssignment

	^ initialNodeAncestors size > 1
		:: and: [ initialNodeAncestors second key isAssignmentNode ]
		:: and: [ initialNodeAncestors second key variable = initialNode key ]! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 9/28/2019 01:41:03'!
isNotATempDeclaration

	| startOfFirstOccurrence sourceRanges tempKey allTempSourceRanges |
	initialNode key isTemp ifFalse: [ ^ true ].
	sourceRanges _ methodNode rawSourceRanges.
	tempKey _ sourceRanges keys detect: [ :parseNode | parseNode isTemp and: [ parseNode equivalentTo: initialNode key ] ].
	allTempSourceRanges _ sourceRanges at: tempKey.
	startOfFirstOccurrence _ allTempSourceRanges isInterval
		ifTrue: [ allTempSourceRanges first ] ifFalse: [ allTempSourceRanges first first ].
	^ startOfFirstOccurrence ~= intervalToExtract first! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 7/6/2019 20:40:51'!
isNotLeftSideOfAssignment 

	^ (self startAndEndParseNodesAreTheSame and: [ self isLeftSideOfAssignment ]) not! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 7/9/2019 15:59:45'!
parseNodesInCommon

	^ initialNodeAncestors intersection: finalNodeAncestors! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 7/9/2019 16:03:15'!
startAndEndNodesShareAParentNode  

	| parseNodesInCommon |
	parseNodesInCommon _ self parseNodesInCommon.
	^ parseNodesInCommon notEmpty and: [
		(self trimmed: parseNodesInCommon first value) = intervalToExtract
	]


! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 7/9/2019 15:59:04'!
startAndEndParseNodesAreTheSame

	^ initialNode key = finalNode key! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 9/28/2019 00:04:36'!
thereAreNoLocalVariableAssignments

	^ methodNode
		allParseNodesWithin: intervalToExtract
		satisfy: [ :parseNode | parseNode isAssignmentToTemporary
			and: [ self isDeclaredWithinIntervalToExtract: parseNode variable ] ]! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 9/8/2019 19:05:37'!
thereAreNoReturnExpressions 

	^ methodNode
		allParseNodesWithin: intervalToExtract
		satisfy: [ :parseNode | parseNode isReturn ]! !

!ExtractMethodExpressionValidation methodsFor: 'validation - private' stamp: 'RNG 7/9/2019 16:03:24'!
trimmed: anInterval

	^ ExtractMethodIntervalTrimmer trim: anInterval locatedIn: sourceCode! !

!ExtractMethodExpressionValidation methodsFor: 'initialization' stamp: 'RNG 9/19/2019 22:14:50'!
initializeFor: anIntervalToExtract of: aMethodUnderValidation

	intervalToExtract _ anIntervalToExtract.
	method _ aMethodUnderValidation! !

!ExtractMethodExpressionValidation class methodsFor: 'instance creation' stamp: 'RNG 7/6/2019 20:07:49'!
for: anIntervalToExtract of: aMethod

	^ self new initializeFor: anIntervalToExtract of: aMethod! !

!ExtractMethodIntervalTrimmer class methodsFor: 'private' stamp: 'RNG 7/6/2019 19:18:23'!
shouldTrim: sourceCode atIndex: currentIndex 

	| currentChar |
	currentChar _ sourceCode at: currentIndex ifAbsent: [ ^ false ].
	^ currentChar isSeparator or: [ currentChar = $. ]
! !

!ExtractMethodIntervalTrimmer class methodsFor: 'evaluating' stamp: 'RNG 7/6/2019 19:22:50'!
trim: anInterval locatedIn: sourceCode

	| trimmedInterval |
	trimmedInterval _ anInterval.
	[ self shouldTrim: sourceCode atIndex: trimmedInterval first ]
		whileTrue: [ trimmedInterval _ trimmedInterval first + 1 to: trimmedInterval last ].
	[ self shouldTrim: sourceCode atIndex: trimmedInterval last ]
		whileTrue: [ trimmedInterval _ trimmedInterval first to: trimmedInterval last - 1 ].
	
	[
		| initialChar endingChar | 
		initialChar _ sourceCode at: trimmedInterval first ifAbsent: [ nil ].
		endingChar _ sourceCode at: trimmedInterval last ifAbsent: [ nil ].
		initialChar = $( and: [ endingChar = $) ]
	 ]
		whileTrue: [ trimmedInterval _ trimmedInterval first + 1 to: trimmedInterval last - 1 ]. 
	
	^ trimmedInterval! !

!Message methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 6/23/2019 20:03:36'!
fullName

	^ String streamContents: [ :messageStream |
		args
			ifEmpty: [ messageStream nextPutAll: selector ]
			ifNotEmpty: [
				self selector keywords withIndexDo: [ :keyword :index |
					messageStream
						nextPutAll: keyword;
						nextPut:  Character space;
						nextPutAll: (args at: index).
					"add an space unless it's the last keyword"
					index = self selector keywords size ifFalse: [ messageStream nextPut: Character space ]
				]
			].
		]! !

!Symbol methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/10/2019 19:09:10'!
isValidSelector

	^ (self isUnary and: [ self allSatisfy: [ :character | character isValidInIdentifiers ] ])
		or: [ self isKeyword and: [ self keywords allSatisfy: [ :keywordString | keywordString allButLast asSymbol isValidSelector ] ] ]! !

!ParseNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/10/2019 17:12:27'!
consolidateAsCollection: sourceRanges

	^ sourceRanges isInterval
		ifTrue: [ OrderedCollection with: sourceRanges ]
		ifFalse: [ sourceRanges ]! !

!ParseNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/28/2019 01:40:07'!
equivalentTo: aParseNode

	^ aParseNode isTemp and: [ self key = aParseNode key ]! !

!ParseNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/7/2019 20:05:56'!
expandIfEnclosedWithParentheses: sourceRange on: sourceCode

	| startsWithParen endsWithParen |
	self flag: #RNG. "take into account other cases: spaces in middle, multiple parenthesis"
	startsWithParen _ (sourceCode at: sourceRange first - 1 ifAbsent: [nil]) = $(.
	endsWithParen _ (sourceCode at: sourceRange last + 1 ifAbsent: [nil]) = $).
	^ startsWithParen & endsWithParen
		ifTrue: [ sourceRange first - 1 to: sourceRange last + 1 ]
		ifFalse: [ sourceRange ]! !

!ParseNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 7/9/2019 15:55:40'!
expandRange: aSourceRange basedOn: sourceRangesOfChildNode

	| intervals |
	intervals _ sourceRangesOfChildNode isInterval
		ifTrue: [ OrderedCollection with: sourceRangesOfChildNode ] ifFalse: [ sourceRangesOfChildNode ].
	intervals withIndexDo: [ :interval :index |
		(interval first > aSourceRange first) ifTrue: [
			^ (aSourceRange first min: (intervals at: index - 1 ifAbsent: [ intervals last ]) first) to: aSourceRange last ] ].
	^ (aSourceRange first min: intervals last first) to: aSourceRange last! !

!ParseNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/10/2019 17:33:30'!
expandRanges: sourceRanges basedOn: allSourceRanges using: sourceCode

	^ (self consolidateAsCollection: sourceRanges)
		collect: [ :sourceRange | self expandIfEnclosedWithParentheses: sourceRange on: sourceCode ]! !

!ParseNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/8/2019 19:05:07'!
isAssignmentToTemporary

	^ false! !

!Encoder methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/7/2019 19:58:40'!
completeSourceRangesBasedOn: sourceCode

	| completeSourceRanges |
	completeSourceRanges _ Dictionary new.
	sourceRanges keysAndValuesDo: [ :parseNode :nodeRanges |
		| expandedNodeSourceRanges |
		expandedNodeSourceRanges _ parseNode expandRanges: nodeRanges basedOn: sourceRanges using: sourceCode.
		completeSourceRanges at: parseNode put: expandedNodeSourceRanges ].
	^ completeSourceRanges! !

!Encoder methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 7/9/2019 11:14:09'!
parseNodesPathAt: aPosition using: expandedSourceRanges ifAbsent: aBlockClosure

	| nodesWithRangeAtPosition |
	nodesWithRangeAtPosition _ SortedCollection sortBlock: [ :nodePathOne :nodePathTwo |
		nodePathOne value first >= nodePathTwo value first and: [
			nodePathOne value last <= nodePathTwo value last ] ].

	expandedSourceRanges associationsDo: [ :nodeAtRange |
		self withRangesOf: nodeAtRange including: aPosition do: [ :aRange |
			nodesWithRangeAtPosition add: (nodeAtRange key -> aRange) ] ].

	^ nodesWithRangeAtPosition
		ifEmpty: aBlockClosure
		ifNotEmpty: [ nodesWithRangeAtPosition ]! !

!AssignmentNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/10/2019 17:14:25'!
expandRanges: aSourceRange basedOn: sourceRanges using: sourceCode

	^ self consolidateAsCollection: (self
		expandRange: (aSourceRange isInterval ifTrue: [ aSourceRange ] ifFalse: [ aSourceRange first ])
		basedOn: (sourceRanges at: variable))! !

!AssignmentNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/8/2019 19:03:48'!
isAssignmentToTemporary

	^ self isAssignmentNode and: [ variable isTemp ]! !

!BlockNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/10/2019 17:13:25'!
expandRanges: sourceRanges basedOn: allSourceRanges using: sourceCode
	"the closure creation node already contains the source ranges including the [ ] and arguments declaration"

	^ self consolidateAsCollection: (allSourceRanges at: closureCreationNode)! !

!BlockNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/10/2019 16:59:24'!
hasTemporaryOrArgumentNamed: aName

	^ (temporaries union: arguments) anySatisfy: [ :temp | temp isNamed: aName ]! !

!LiteralNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/19/2019 21:32:10'!
equivalentTo: aParseNode

	^ aParseNode isLiteralNode and: [ self key = aParseNode key ]! !

!VariableNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/8/2019 20:46:04'!
isNamed: aName

	^ self name = aName! !

!MessageNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/19/2019 21:31:18'!
equivalentTo: aParseNode

	self flag: #RNG. "complete definition by checking each argument"
	^ aParseNode isMessageNode
		:: and: [ self receiver equivalentTo: aParseNode ]
		:: and: [ self selector = aParseNode selector ]
		:: and: [ self arguments isEmpty ]! !

!MessageNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/19/2019 21:16:03'!
expandRanges: aSourceRange basedOn: sourceRanges using: sourceCode

	| receiverExpandedRanges expandedRangeWithReceiver |
	receiverExpandedRanges _ self isCascade
		ifTrue: [ self flag: #RNG . aSourceRange ] "fix source ranges for cascade messages"
		ifFalse: [ receiver expandRanges: (self receiverSourceRangesFrom: sourceRanges) basedOn: sourceRanges using: sourceCode ].
	expandedRangeWithReceiver _ self
		expandRange: (aSourceRange isInterval ifTrue: [ aSourceRange ] ifFalse: [ aSourceRange first ])
		basedOn: receiverExpandedRanges.
	^ self consolidateAsCollection: (self expandIfEnclosedWithParentheses: expandedRangeWithReceiver on: sourceCode)! !

!MessageNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/19/2019 21:24:41'!
receiverSourceRangesFrom: sourceRanges
	"we can't just do #at: because sometimes what it is on the source ranges map
	is not the exact same object than the receiver or the originalReceiver
	(like when optimizations are made), so we look for an 'equivalent' one
	(at least for using as a key in the source ranges)"

	^ sourceRanges at: receiver ifAbsent: [
		| parseNodeOfReceiver |
		parseNodeOfReceiver _ sourceRanges keys detect: [ :parseNode |
		(parseNode equivalentTo: receiver) or: [ parseNode equivalentTo: originalReceiver ] ].
		sourceRanges at: parseNodeOfReceiver
	]! !

!MethodNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/10/2019 17:19:25'!
allParseNodesWithin: aSourceCodeInterval satisfy: aCondition

	self completeSourceRangesDo: [ :parseNode :sourceRanges |
		(aCondition value: parseNode) ifTrue: [
			sourceRanges anySatisfy: [ :sourceRange | aSourceCodeInterval rangeIncludes: sourceRange first ]
				:: ifTrue: [ ^ false ]
		] ].
	^ true! !

!MethodNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/7/2019 20:00:55'!
completeSourceRanges
	"Returns the 'expanded' version of the source ranges, for instance in message sends it also includes the receiver, and if there are parentheses they are included in the source range as well. Right now used for refactorings."

	^ encoder completeSourceRangesBasedOn: self sourceText! !

!MethodNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/10/2019 17:10:08'!
completeSourceRangesDo: aBinaryBlock
	"block has to receive parse node and collection of source ranges"

	^ self completeSourceRanges keysAndValuesDo: aBinaryBlock! !

!MethodNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/8/2019 20:46:33'!
hasTemporaryOrArgumentNamed: aName

	^ (temporaries union: arguments) anySatisfy: [ :temp | temp isNamed: aName ]! !

!MethodNode methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 9/7/2019 19:41:58'!
parseNodesPathAt: aPosition ifAbsent: aBlockClosure

	^ encoder
		parseNodesPathAt: aPosition
		using: self completeSourceRanges
		ifAbsent: aBlockClosure! !

!SmalltalkEditor methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/28/2019 00:59:01'!
extractMethod

	"hack to prevent the extract method to be evaluated on editors w/o methods like the workspace"
	(self codeProvider respondsTo: #currentCompiledMethod) ifFalse: [ ^ nil ].

	morph owningWindow okToChange ifTrue: [
		ExtractMethodApplier createAndValueHandlingExceptions: [
			ExtractMethodApplier for: self selectionInterval of: self codeProvider currentCompiledMethod ] ]! !

!SmalltalkEditor methodsFor: '*Refactorings-ExtractMethod' stamp: 'RNG 5/9/2019 00:06:54'!
extractMethod: aKeyboardEvent

	self extractMethod.
	^true! !
