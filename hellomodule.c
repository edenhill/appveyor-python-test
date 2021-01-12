#include <Python.h>

#include <librdkafka/rdkafka.h>
/*
 * Module method definition.
 * This is the code that will be invoked by `hello.say_hello`.
 */
static PyObject* say_hello(PyObject* self, PyObject* args)
{
    const char* name;

    if (!PyArg_ParseTuple(args, "s", &name))
        return NULL;

    printf("Hello %s!\n", name);
    printf("On librdkafka version %s\n", rd_kafka_version_str());

    Py_RETURN_NONE;
}

/*
 * Method definition.
 *
 * ml_name: Method name
 * ml_meth: Pointer to the method implementation
 * ml_flags: Flags indicating special features of the method
 * ml_doc: Method's docstring
 */
static PyMethodDef HelloMethods[] =
{
     {"say_hello", say_hello, METH_VARARGS, "Greet somebody."},
     {NULL, NULL, 0, NULL}
};


PyMODINIT_FUNC
#if PY_MAJOR_VERSION >= 3
PyInit_hello(void)
#else
inithello(void)
#endif
{
#if PY_MAJOR_VERSION >= 3
  static struct PyModuleDef moduledef = {
        PyModuleDef_HEAD_INIT,
        "hello",     /* m_name */
        "This is a Py3 module",  /* m_doc */
        -1,                  /* m_size */
        HelloMethods,    /* m_methods */
        NULL,                /* m_reload */
        NULL,                /* m_traverse */
        NULL,                /* m_clear */
        NULL,                /* m_free */
    };
  return PyModule_Create(&moduledef);
#else
  Py_InitModule3("hello", HelloMethods, "This is a Py2 module");
#endif
}
