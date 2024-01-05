
class NotNumericalException(Exception):
    pass

def add(a, b):
    if type(a) not in [int, float] or type(b) not in [int, float]:
        raise NotNumericalException()
    else:
        return a+b