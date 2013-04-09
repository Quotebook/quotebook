#if OFFLINE

#define QBServiceCommand(commandName, inputType, outputType, stubbedOutputBlock)                \
    ImplementStubbedServiceCommand(commandName, inputType, outputType, stubbedOutputBlock)

#define QBServiceComandNoInput(commandName, outputType, stubbedOutputNoInputBlock)              \
    ImplementStubbedServiceCommandNoInput(commandName, outputType, stubbedOutputNoInputBlock) 

#define QBServiceCommandNoResponse(commandName, inputType, stubbedBlockArg)                                      \
    ImplementStubbedServiceCommandNoResponse(commandName, inputType, stubbedBlockArg)

#define QBServiceCommandNoInputNoResponse(commandName, stubbedBlockArg)                                          \
    ImplementStubbedServiceCommandNoInputNoResponse(commandName, stubbedBlockArg)

#else

#define QBServiceCommand(commandName, inputType, outputType, stubbedOutputBlock)                \
    ImplementServiceCommand(commandName, inputType, outputType)

#define QBServiceComandNoInput(commandName, outputType, stubbedOutputNoInputBlock)              \
    ImplementServiceCommandNoInput(commandName, outputType)

#define QBServiceCommandNoResponse(commandName, inputType, stubbedBlockArg)                                      \
    ImplementCommandNoResponse(commandName, inputType) <-- VERIFY NAME

#define QBServiceCommandNoInputNoResponse(commandName, stubbedBlockArg)                                          \
    ImplementCommandNoInputNoResponse(commandName) <-- VERIFY NAME

#endif