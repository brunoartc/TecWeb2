package br.edu.insper.TecWeb;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.concurrent.ThreadLocalRandom;

import org.json.JSONObject;

public class Resources {

	@Value("${gif_api_key}")
	private String giphyKey;
	
	private final String USER_AGENT = "Mozilla/5.0";

	// TODO: adicionar API de GIFS, pode ser ao checar por --GIF-- no content da
	// nota

	// www.reddit.com/r/Showerthoughts/search?q=teste&restrict_sr=1%2F.json&sort=top


	private String sendGet(String url) throws Exception {

		URL obj = new URL(url);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();

		// optional default is GET
		con.setRequestMethod("GET");

		// add request header
		con.setRequestProperty("User-Agent", USER_AGENT);

		int responseCode = con.getResponseCode();
		System.out.println("\nSending 'GET' request to URL : " + url);
		System.out.println("Response Code : " + responseCode);

		BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();

		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();

		// print result
		return (response.toString());

	}

	public String redditAPI(String subreddit, String search) {

		try {
			JSONObject obj = null;
			if (search != "") {
				obj = new JSONObject(sendGet(
						"https://www.reddit.com/r/Showerthoughts/search.json?q=" + search + "&restrict_sr=1&sort=top"));

			} else {

				obj = new JSONObject(sendGet("https://www.reddit.com/r/Showerthoughts/.json"));
			}

			Integer numItens = obj.getJSONObject("data").getInt("dist");
			Integer randowm = ThreadLocalRandom.current().nextInt(1, numItens);
			String resp = obj.getJSONObject("data").getJSONArray("children").getJSONObject(randowm)
					.getJSONObject("data").getString("title");

			return resp;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return (e.toString());
		}
	}

	public String GIF_API(String search) {

		try {
			JSONObject obj = null;
			if (search != "") {
				obj = new JSONObject(sendGet("http://api.giphy.com/v1/gifs/random?tag=" + search + "api_key=" + giphyKey));

			} else {

				obj = new JSONObject(sendGet("http://api.giphy.com/v1/gifs/random?api_key=" + giphyKey));
			}	
			
			String resp = obj.getJSONObject("data").getJSONObject("images").getJSONObject("downsized_medium").getString("url");
			
			return resp;			

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return (e.toString());
		}
	}

}
