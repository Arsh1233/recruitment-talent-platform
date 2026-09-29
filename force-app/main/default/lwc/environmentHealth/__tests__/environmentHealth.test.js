import { createElement } from "lwc";
import EnvironmentHealth from "c/environmentHealth";

describe("c-environment-health", () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  it("shows the environment-ready message", () => {
    const element = createElement("c-environment-health", {
      is: EnvironmentHealth
    });

    document.body.appendChild(element);

    const status = element.shadowRoot.querySelector('[data-testid="status"]');
    expect(status.textContent).toContain("environment is ready");
  });
});
