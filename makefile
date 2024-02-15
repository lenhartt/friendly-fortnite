TARGET = "."

ifeq (, $(shell which love))
$(error "")
endif

run: 
	@clear && love $(TARGET)
