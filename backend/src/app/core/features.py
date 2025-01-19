class FeatureManager:
    def __init__(self, app_id: str):
        self.app_id = app_id
        self.features = load_features(app_id)

    def is_enabled(self, feature: str) -> bool:
        return self.features.get(feature, False)
