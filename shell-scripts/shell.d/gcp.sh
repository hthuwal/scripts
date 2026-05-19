# Function to open the airflow ui for a cloud composer project
function airflowui() {
	local project_id="$1"
	local location="${2:-us-central1}"

	if [[ -z "$project_id" ]]; then
		gum style --foreground 196 "Usage: airflow_ui <project-id> [location]"
		return 1
	fi

	local airflow_uri
	airflow_uri=$(gcloud composer environments list \
		--project "$project_id" \
		--locations "$location" \
		--format="value(config.airflowUri)" 2>/dev/null | head -1)

	if [[ -z "$airflow_uri" ]]; then
		gum style --foreground 196 "No Composer environment found in '$project_id' ($location)."
		return 1
	fi

	gum style --foreground 82 "Opening: $airflow_uri"
	open "$airflow_uri"
}