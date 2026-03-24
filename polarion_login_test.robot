***Settings***
Library    SeleniumLibrary    # This library provides keywords for web browser automation
Library    OperatingSystem    # To interact with the operating system, e.g., for screenshots

***Variables***
# Define variables for your Polarion instance
# IMPORTANT: In a real project, DO NOT hardcode passwords here.
# Use variable files, environment variables, or secret management.
${POLARION_URL}             http://pl1chzrh0298nb/polarion/#/project/SiemensDemo/home # Direct URL to the project home
${USERNAME}                 lVoillat
${PASSWORD}                 1
${BROWSER}                  Chrome             # You can change this to Firefox, Edge, etc.
${DELAY}                    0.5s               # Small delay for general pauses (use sparingly)
${DASHBOARD_ELEMENT_ID}     DOM_13             # The ID for the dashboard content element you expect
${LOGIN_TIMEOUT}            15s                # Timeout for login-related waits
${DASHBOARD_LOAD_TIMEOUT}   30s                # Longer timeout for dashboard element presence

***Test Cases***
Successfully Log In to Polarion
    [Documentation]    This test verifies that a user can successfully log in to Polarion.
    Open Browser To Polarion Login Page
    Input Login Credentials
    Verify Successful Login

***Keywords***
Open Browser To Polarion Login Page
    [Documentation]    Opens the specified browser and navigates to the Polarion login page (or project home).
    Open Browser    ${POLARION_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains    Polarion    timeout=${LOGIN_TIMEOUT}    error=Polarion page did not load within ${LOGIN_TIMEOUT}.
    Log    Navigated to Polarion URL: ${POLARION_URL}

Input Login Credentials
    [Documentation]    Inputs the username and password into the login form, then waits for the page to settle.
    Wait Until Element Is Visible    id=j_username    timeout=${LOGIN_TIMEOUT}    error=Username field (id=j_username) not found.
    Input Text    id=j_username    ${USERNAME}
    Input Password    id=j_password    ${PASSWORD}    # Use Input Password for sensitive fields
    Click Button    id=submitButton

    # Wait for any "loading" indicators to disappear.
    Wait Until Page Does Not Contain    Please wait...    timeout=${LOGIN_TIMEOUT}
    Wait Until Page Does Not Contain    Loading...        timeout=${LOGIN_TIMEOUT}

    # --- CRITICAL CHANGE: Using Wait Until Element Is Enabled for DOM presence ---
    # This keyword is the closest equivalent to Java's ExpectedConditions.presenceOfElementLocated
    # It checks if the element is in the DOM, without necessarily checking for visual visibility.
    Wait Until Element Is Enabled    id=${DASHBOARD_ELEMENT_ID}    timeout=${DASHBOARD_LOAD_TIMEOUT}    error=Post-login page did not load dashboard content (id=${DASHBOARD_ELEMENT_ID}) within ${DASHBOARD_LOAD_TIMEOUT}.

    # Now that the element is present in the DOM, capture the diagnostic screenshot.
    Capture Page Screenshot    after_login_button_click_and_load.png
    Log To Console    Captured screenshot: after_login_button_click_and_load.png

Verify Successful Login
    [Documentation]    Verifies that the login was successful by checking for elements on the dashboard.
    # At this point, the dashboard element should already be present in the DOM.
    # We can add a quick check that it's still present.
    Element Should Be Enabled    id=${DASHBOARD_ELEMENT_ID}    # Quick check that it's still present/enabled

    # Check for common login failure messages (though the above wait should prevent this from being hit if failed)
    Page Should Not Contain    Invalid Username or Password    error=Login failed: Invalid Username or Password.
    Page Should Not Contain    Login Failed                    error=Login failed: Generic "Login Failed" message found.

    Log To Console    Login successful for user: ${USERNAME}
    Capture Page Screenshot    login_success.png    # Take a screenshot on success
    Log To Console    Captured screenshot: login_success.png
    Close Browser
