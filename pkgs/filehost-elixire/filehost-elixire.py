# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "aiohttp"
# ]
# ///

import os
from pathlib import Path
from aiohttp import ClientSession, FormData, web

session = web.AppKey("session", ClientSession)


async def handle(request):
    f = FormData()
    f.add_field("f", request.content, filename="f", content_type=request.content_type)
    async with request.app[session].post("/api/upload", data=f) as resp:
        if resp.status != 200:
            return web.Response(
                status=resp.status,
                content_type=resp.content_type,
                body=await resp.read(),
            )
        json = await resp.json()
        return web.Response(status=201, headers={"Location": json["url"]})


async def app_factory():
    app = web.Application()
    apikey_path = os.getenv("APIKEY_PATH", "/home/leo60228/.config/elixire-apikey")
    apikey = Path(apikey_path).read_text().strip()
    app[session] = ClientSession(
        "https://elixi.re",
        headers={"Authorization": apikey},
    )
    app.add_routes([web.post("/upload", handle)])
    return app


if __name__ == "__main__":
    web.run_app(app_factory(), host="localhost", port=40413)
