# Deck da Villa · prototype

Responsive guest booking flow and staff reservation dashboard, built as a local static prototype. The visuals follow the captured Deck da Villa site and use local copies of its public room and property images.

## Run locally

From this directory, run:

```bash
python3 -m http.server 4178
```

Open <http://127.0.0.1:4178/>. The first view is the guest-facing site. Use **Painel da equipe** in the header or **Acesso da equipe** in the footer to open the mock PMS dashboard. The booking form, demo reservation modal, dashboard search and filters, new demo reservation form, and CSV export work in the browser.

## Sandbox notes

- This is frontend-only. It has no server, account, payment processor, or PMS/channel-manager connection.
- Reservations, guest details, values, statuses, dashboard metrics, and arrivals are fictional examples held in browser memory.
- The site and dashboard show sandbox labels; booking actions do not contact the inn or create a real reservation.
- Photos are copies of publicly served images from `deckdavilla.com`, included locally for the prototype.
- Font downloads are optional; system serif/sans fallbacks are configured.

## Files

- `index.html` — guest website and staff dashboard markup
- `styles.css` — responsive visual system and layouts
- `app.js` — mock booking and dashboard interactions
- `assets/` — local reference photography
