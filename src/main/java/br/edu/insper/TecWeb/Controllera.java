package br.edu.insper.TecWeb;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class Controllera {

	@Value("${mymessage}")
	private String message;

	@GetMapping("/ResponseTemplateDefault")
	public String responseTemplateDefault(Model model) {

		model.addAttribute("message", message);
		return "mama.jsp";
	}

	@GetMapping("/ResponseTemplateInFolder")
	public String responseTemplateInFolder(Model model) {

		model.addAttribute("message", message);
		return "teste/mama.jsp";
	}

	@GetMapping("/ResponseString")
	@ResponseBody
	public String responseString() {

		return "Response!";
	}

}
