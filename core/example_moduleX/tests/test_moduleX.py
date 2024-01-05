import pytest
from example_moduleX.moduleX import add, NotNumericalException

def test_add_should_work_on_numerical_values():
    assert add(1, 1)==2
    assert add(2, 1)==3
    assert add(1.5, 2.5)==4
    assert add(-4, 5)==1

def test_add_should_fail_on_string_values():
    with pytest.raises(NotNumericalException):
        add(1, '1')