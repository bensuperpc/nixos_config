import sqlite3

import fastapi
import pandas as pd
import requests
import uvicorn


def add(a: int, b: int) -> int:
    return a + b


def main() -> None:
    assert add(2, 2) == 4

    df = pd.DataFrame({"x": [1, 2, 3]})
    assert df["x"].sum() == 6

    conn = sqlite3.connect(":memory:")
    conn.execute("CREATE TABLE t (x INTEGER)")
    conn.close()

    assert fastapi.__version__
    assert requests.__version__
    assert uvicorn.__version__

    print("Python devshell OK: 2 + 2 =", add(2, 2))


if __name__ == "__main__":
    main()
