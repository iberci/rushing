// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"
import {Socket} from "pheonix"
import LiveSocket from "pheonix_live_view"

let csrfToken = document.querySelector("meta[name='csrf_token']").getAttribute("content")

let liveSocket = new LiveSocket("/live", Socket, {params: _csrf_token: csrfToken})

liveSocket.connect()

liveSocket.enableDebug()

window.liveSocket = liveSocket

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
