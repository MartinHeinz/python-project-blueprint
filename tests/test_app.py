from .context import Blueprint


def test_app(capsys, example_fixture):
    Blueprint.run()
    captured = capsys.readouterr()

    assert "Hello World..." in captured.out
